module Transform

  class Output
    public

    attr_accessor :dir, :name, :ext

    def initialize dir, name, ext
      self.dir = dir
      self.name = name
      self.ext = ext
    end

    def filepath
      File.join(self.dir, "#{name}.#{ext}")
    end

    def file(&block)
      FileUtils.mkpath dir
      File.open(filepath, "w", &block)
    end
  end

  def before_model_lambda model: nil
    return [model: model]
  end

  def after_model_lambda model: nil, before: nil
    return [model: model, before: before]
  end

  def before_group_lambda name: nil
    return [name: name]
  end

  def after_group_lambda name: nil, before: nil, depth: 0
    return [name: name, before: before, depth: depth]
  end

  def before_type_lambda type: nil, depth: 0, index: 0, total: 1
    return [type: type, depth: depth, index: index, total: total]
  end

  def after_type_lambda type: nil, before: nil, depth: 0
    return [type: type, before: before, depth: depth]
  end

  def before_array_lambda name: nil, decl: nil, depth: 0, total: 1
    return [name: name, decl: decl, depth: depth, total: total]
  end

  def after_array_lambda index: 0, decl: nil, depth: 0, before: nil
    return [index: index, decl: decl, depth: depth, before: before]
  end

  def attribute_lambda id:, val:, depth: 0, type: nil, index:, total:
    return [id: id, val: val, depth: depth, type: type, index: index, total: total]
  end

  # @param models - the models to transform
  # @lambdas - set of function callbacks to transform

  def transform_datamodel lambdas, *models, deeplink: false
    for model in models
      dom = cond_call(lambdas, :before_model, *before_model_lambda(model: model))
      for typename in model.contents.keys
        grp = cond_call(lambdas, :before_group, *before_group_lambda(name: typename))
        t = 0
        # there will be more than one of each type
        for type in model.contents[typename]
          transform_array_type_or_attribute(lambdas, decl: type, name: typename, depth: 0, index: 0, total: 1, deeplink: deeplink)
          t = t + 1
        end
        grp = cond_call(lambdas, :after_group, *after_group_lambda(name: typename, before: grp))
      end
      cond_call(lambdas, :after_model, *after_model_lambda(model: model, before: dom))
    end
  end

  def transform_metamodel lambdas, *models
    for model in models
      dom = cond_call(lambdas, :before_model, *before_model_lambda(model: model))
      for type in model.types.values
        before = cond_call(lambdas, :before_type, *before_type_lambda(type: type, index: 0, total: 1))
        i = 0
        for ak in type.attributes.keys
          av = type.attributes[ak]
          cond_call(lambdas, :attribute, *attribute_lambda(id: ak, val: av, type: type, index: i, total: type.attributes.keys.length))
          i = i + 1
        end
        cond_call(lambdas, :after_type, *after_type_lambda(type: type, before: before))
      end
      cond_call(lambdas, :after_model, *after_model_lambda(model: model, before: dom))
    end
  end

  def models_to_data(models, deeplink: false)
    map = Hash.new
    stack = [map]
    transform_datamodel(
        {
            :before_group => lambda do |name:|
              # group all instances of the same type name into the same array in the top level map
              if map[name]
                stack.push(map[name])
              else
                n = Array.new
                map[name] = n
                stack.push(map[name]) # add a new container to the stack to use next
              end
            end,
            :before_type => lambda do |type:, depth:, index:, total:|
              last = stack.last
              n = Hash.new
              stack.push(n) # add a new container to the stack to use next
              if last.class <= Hash
                last[type.name] = n
              elsif last.class <= Array
                last.push(n)
              end
            end,
            :before_array => lambda do |name:, decl:, depth:, total:|
              last = stack.last
              n = Array.new
              if last.class <= Array
                last << n
              else
                last[name] = n
              end
              stack.push(n) # add a new container to the stack to use next
            end,
            :attribute => lambda do |id:, val:, depth:, type:, index:, total:|
              last = stack.last
              if last.class <= Hash
                last[id] = val
              elsif last.class <= Array
                last.push val
              end
            end,
            :after_group => lambda do |name:, depth:, before:|
              stack.pop
            end,
            :after_type => lambda do |type:, depth:, before:|
              stack.pop
            end,
            :after_array => lambda do |index:, decl:, depth:, before: nil|
              stack.pop
            end,
        }, *models, deeplink: deeplink)
    map
  end

  def metamodels_to_data(models)
    map = Hash.new
    transform_metamodel(
        {
            :before_model => lambda do |model:|
              map[model.name.to_sym] = {}
            end,
            :before_type => lambda do |type:, depth:, index:, total:|
              map[type.domain.name.to_sym][type.typename] = {}
            end,
            :attribute => lambda do |id:, val:, type:, depth:, index:, total:|
              val = val.clone.keep_if{|k,v|v}
              #yaml converter is a bit thick, so we need to convert objects to strings
              val[:multiplicity] = pretty_multiplicity(val)
              val[:type] = val[:type].to_s
              val[:links] = val[:links].to_s if val.has_key? :links
              map[type.domain.name.to_sym][type.typename][id] = val
            end,
        }, *models)
    map
  end

  def pretty_multiplicity m
    m = m[:multiplicity]
    if m.end == -1
      if m.begin == 0
        return "*"
      else
        return "#{m.begin}..*"
      end
    end
    if m.end == m.begin
      return m.end.to_s
    end
    return m.to_s
  end


  private

  def cond_call(lambdas, lam, *args)
    if lambdas[lam]
      return lambdas[lam].(*args)
    end
    return 0
  end


  def transform_array_type_or_attribute(lambdas, index:, name:, decl:, depth:, total:, deeplink:)

    if decl.class <= Array
      arrctx = cond_call(lambdas, :before_array, *before_array_lambda(name: name, decl: decl, depth: depth, total: decl.length))
      j = 0
      for aa in decl
        transform_array_type_or_attribute(lambdas, index: j, decl: aa, name: name, depth: depth, total: decl.length, deeplink: deeplink)
        j = j + 1
      end
      cond_call(lambdas, :after_array, *after_array_lambda(index: index, decl: decl, depth: depth, before: arrctx))
    elsif decl.class <= DataType
      before = cond_call(lambdas, :before_type, *before_type_lambda(type: decl, depth: depth, index: index, total: total))
      i = 0
      for ak in decl.attributes.keys
        av = decl.attributes[ak]
        typeinfo = decl.class.attributes[ak]
        transform_array_type_or_attribute(lambdas, name: ak, decl: av, depth: depth + 1, index: i, total: decl.attributes.keys.length, deeplink: deeplink)
        if deeplink and nil != typeinfo[:links]
          for al in typeinfo[:links].instances
            if av == al.attributes[:id]
              transform_array_type_or_attribute(lambdas, name: ak, decl: al, depth: depth + 1, index: i, total: decl.attributes.keys.length, deeplink: deeplink)
            end
          end
        end
        i = i + 1
      end
      cond_call(lambdas, :after_type, *after_type_lambda(type: decl, depth: depth, before: before))
    else
      cond_call(lambdas, :attribute, *attribute_lambda(id: name, val: decl, index: index, depth: depth, total: total))
    end
    self
  end


end