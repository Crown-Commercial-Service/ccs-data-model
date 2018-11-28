require 'date'

module DataModel


  SINGLE = 1..1
  ZERO_OR_ONE = 0..1
  ONE_TO_MANY = 1..-1
  ZERO_TO_MANY = 0..-1

  class DataType

    class << self

      def init(name, domain, extends, description)
        @attributes = {}
        @typename = name
        @domain = domain
        @extends = extends
        @description = description
        @instances = []

        self.define_singleton_method :domain do
          @domain
        end
        self.define_singleton_method :description do
          @description
        end

        self.define_singleton_method(:attributes) do |inherited = true|
          if inherited && self.superclass.respond_to?(:attributes)
            self.superclass.attributes.merge @attributes
          else
            @attributes
          end
        end

      end

      def instances
        @instances
      end

      def typename
        @typename
      end

      alias name typename

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

    attr_reader :name, :attributes

    def initialize(name, attributes = {}, &initialize_block)
      @name = name
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
        if !self.respond_to? :include
          self.define_singleton_method :include do |&block|
            self.instance_exec(&block)
          end
        end
      end

      if block_given?
        self.instance_exec(&initialize_block)
      end
    end

    def to_s
      "#{self.class.typename} #{self.name} #{@attributes}"
    end

    private

    def valueof(sym, *args, &block)
      if self.class.attributes[sym][:type] < DataType
        at = self.class.attributes[sym][:type].new(self.class.attributes[sym][:name])
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
      def datatype(name, extends: DataType, description: "", &block)
        unless instance_variable_defined? :@types
          @types = {}
          self.define_singleton_method(:types) {@types}
        end
        extends = getType(extends)
        type = self.const_set name, Class.new(extends)
        @types[name] = type
        dom = self
        type.instance_exec do
          init name, dom, extends, description
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
            raise "Can't find type #{typeref} in #{typeref}"
          end
          return types[typeref]
        elsif typeref.class == Class
          return typeref
        else
          raise "type refs must be symbol or DataType class"
        end
      end

    end

    attr_reader :contents, :name

    def initialize(name, &initialise_block)
      @contents = {}
      @name = name.to_sym
      self.class.const_set name.to_sym, self

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
          decl = t.new(k)
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
    if block_given?
      dom.instance_exec(&block)
    end
    return dom
  end

  module_function

  def date(day, month, year)
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
  def Enum(scheme, *code_ids, code_type: :code, code_key: :id, scheme_desc: :id)
    if( !(scheme.class <= DataType))
      raise "doc for Enum needs to be a data type with many type values as an attribute 'codekey'"
    end
    if (code_ids.length == 0)
      code_ids = scheme.attributes[code_type].map {|code| code.attributes[code_key]}
    end
    typename = "ENUM_#{code_ids.join '_'}"
    selclass = Object.const_set typename, Class.new(Selection)
    selclass.define_singleton_method(:ids) {code_ids}
    selclass.define_singleton_method(:scheme) {scheme}
    selclass.define_singleton_method(:to_s) {"#{self.scheme.attributes[scheme_desc]}(#{self.ids.join(',')})"}
    return selclass
  end


end # DataModel

class Class
  def typename
    return self.name
  end
end