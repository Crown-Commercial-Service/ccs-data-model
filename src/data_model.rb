require 'date'
require 'semantic'
include Semantic

module DataModel


  SINGLE = 1..1
  ZERO_OR_ONE = 0..1
  ONE_TO_MANY = 1..-1
  ZERO_TO_MANY = 0..-1

  class DataType

    class << self

      def init(name:, domain:, extends:, union: false, description:)
        @attributes = {}
        @typename = name
        @domain = domain
        @extends = extends
        @description = description
        @instances = []
        @union = union

        self.define_singleton_method(:attributes) do |inherited = true|
          if inherited && self.superclass.respond_to?(:attributes)
            self.superclass.attributes.merge @attributes
          else
            @attributes
          end
        end

      end

      def domain
        @domain
      end

      def description
        @description
      end

      def instances
        @instances
      end

      def typename
        @typename
      end

      def union
        @union
      end

      def extends
        @extends < DataType ? @extends.name : nil
      end

      def attribute(name, type, *args, multiplicity: SINGLE,
                    description: "", links: nil, source: nil, example: nil)
        type = getType(type)
        options = {:multiplicity => multiplicity, :description => description, :name => name, :type => type, :source => source, :example => example}
        options[:links] = getType(links)

        for opt in args
          if opt.is_a? Range
            options[:multiplicity] = opt
          elsif opt.is_a? String
            options[:description] = opt
          else
            raise "optional arguments should be string (description), or range\n " << opt.to_s
          end
        end

        @attributes[name] = options
      end

      private

      def getType(typeref)
        domain.getType typeref
      end

    end

    attr_reader :name, :domain, :attributes
    attr_accessor :container

    def initialize(name, domain, attributes = {}, &initialize_block)
      @name = name
      @domain = domain
      @attributes = attributes

      self.class.instances << self

      self.class.attributes.keys.each do |k|
        # add a definition / accessor for each attribute
        self.define_singleton_method(k) do |*args, &block|
          if args.length == 0 && !block
            unless @attributes[k]
              puts ("Warning - reading unset attribute '#{k}' on #{self.class}")
            end
            return @attributes[k]
          end
          if block
            value = valueof(k, *args, &block)
          else
            value = args[0]
          end
          value = check_and_convert(value, self.class.attributes[k][:type])
          if self.class.attributes[k][:multiplicity].end != 1
            @attributes[k] = [] unless @attributes[k]
            @attributes[k] << value
          else
            @attributes[k] = value
          end
          return value
        end
        self.define_singleton_method("#{k}=".to_sym) do |val|
          @attributes[k] = val
          val
        end
        if !self.respond_to? :macro
          self.define_singleton_method :macro do |&block|
            self.instance_exec(&block)
          end
        end
      end

      if block_given?
        self.instance_exec(&initialize_block)
      end
    end

    def check_and_convert(value, type)
      if (type <= Version && value.class <= String)
        return Version.new value
      end
      value
    end

    def to_s
      "#{self.class.typename} #{self.name} #{@attributes}"
    end

    private

    def valueof(sym, *args, &block)
      type = self
      if self.class.attributes[sym][:type] < DataType
        at = self.class.attributes[sym][:type].new(self.class.attributes[sym][:name], self)
        at.container = type
        if nil == block
          raise "Need a block for a nested type #{sym} in #{self}"
        end
        at.instance_exec(&block)
        return at
      else
        args[0]
      end
    end

  end

  class Domain

    class << self

      def init(name)
        @name = name
        @instances = []

      end

      def instances
        @instances
      end

      def neme
        @name
      end

      def datatype(name, extends: DataType, description: "", union: false, &block)
        unless instance_variable_defined? :@types
          @types = {}
          self.define_singleton_method(:types) {@types}
        end
        extends = getType(extends)
        type = self.const_set name, Class.new(extends)
        @types[name] = type
        dom = self
        type.instance_exec do
          init(name: name, domain: dom, extends: extends, union: union, description: description)
        end
        type.instance_exec(&block)
        type
      end

      def getType(typeref)
        if !typeref
          return nil
        end
        if typeref.class == Symbol
          if !types[typeref]
            raise "Can't find type #{typeref} "
          end
          return types[typeref]
        elsif typeref.class == Class
          return typeref
        else
          raise "type specifications must be symbol or DataType class '#{typeref}'"
        end
      end

    end

    attr_reader :contents, :name

    def initialize(name, &initialise_block)
      @contents = {}
      @name = name.to_sym
      self.class.const_set name.to_sym, self

      self.class.instances << self
      dom = self

      self.class.types.values.each do |t|
        # add a definition / accessor for each type
        k = t.typename.downcase
        self.define_singleton_method(k.to_sym) do |*args, &block|
          if args.length == 0 && !block
            unless @contents[k]
              raise("reading unset type decl #{k} on #{self}")
            end
            return @contents[k]
          end
          decl = t.new(k, dom)
          @contents[k] = [] unless @contents[k]
          @contents[k] << decl
          if block_given?
            decl.instance_exec(&block)
          else
            puts "warning: no block given for type #{k} in #{self}"
          end
          return decl
        end
      end

      if block_given?
        self.instance_exec(&initialise_block)
      end
    end

  end


  module_function

  def domain(name, &block)
    dom = Object.const_set name.to_sym, Class.new(Domain)

    dom.instance_exec do
      init name
    end

    if block_given?
      dom.instance_exec(&block)
    end
    return dom
  end

  module_function

  def _date(day, month, year)
    Date.new(day, month, year)
  end

  def api(name, &block)
    api = Object.const_set name.to_sym, Class.new(API)
    if block_given?
      api.instance_exec(&block)
    end
    return api
  end

  class Selection < Symbol
  end

  # create an enumeration class derived from Symbol
  #
  def Enum(doc, *codes, code_type: :standard, code_key: :uri, name_key: :id, doc_id: :id)
    begin
      if (!(doc.class <= DataType))
        raise "standard #{doc} for Enum needs to be a data type with many type values as an attribute 'codekey'"
      end
      if (codes.length == 0)
        codes = doc.attributes[code_type]
      end
      code_ids = codes.map {|code| code.attributes[code_key]}
      name_ids = codes.map {|code| code.attributes[name_key]}

      typename = "ENUM_#{name_ids.join '_'}".gsub(/[:-]/, '_')
      selclass = Object.const_set typename, Class.new(Selection)
      selclass.define_singleton_method(:ids) {code_ids}
      selclass.define_singleton_method(:doc) {doc}
      selclass.define_singleton_method(:id) {doc.id}
      selclass.define_singleton_method(:uri) {doc.uri}
      selclass.define_singleton_method(:url) {doc.url}
      selclass.define_singleton_method(:to_s) {"#{self.doc.attributes[doc_id]}( #{self.ids.join(', ')})"}
      return selclass
    rescue StandardError => err
      raise "can't get codes out of #{doc} \n#{code_type} #{code_key} #{name_key} #{doc_id}\n: #{err}"
    end
  end

  #borrowed from rubocop
  def snake_case(camel_case_string)
    snake = camel_case_string.to_s
                .gsub(/([^A-Z])([A-Z]+)/, '\1_\2')
                .gsub(/([A-Z])([A-Z][^A-Z\d]+)/, '\1_\2')
                .downcase
    if (camel_case_string.class <= Symbol)
      snake.to_sym
    else
      snake
    end
  end

end # DataModel

