require_relative '../src/data_model'
include DataModel

domain :ReferenceData do

  datatype(:Code) {
    attribute :id, String
    attribute :title, String
    attribute :description, String
  }

  datatype(:SchemeCode, extends: :Code) {
    attribute :source, String
  }

  datatype(:DataDocument) {
    attribute :id, String
    attribute :title, String
    attribute :description, String
    attribute :version, String
  }

  datatype(:SchemeOfSchemes, extends: :DataDocument) {
    attribute :code, :SchemeCode, ZERO_TO_MANY
  }

  datatype(:CodingScheme, extends: :DataDocument) {
    attribute :code, :Code, ZERO_TO_MANY
  }

end

class Selection < Symbol
end

# create an enumeration class derived from Symbol
def Enum(doc, *code_ids)
  if(code_ids.length == 0)
    code_ids= doc.attributes[:code].map{ |code| code.id}
  end
  typename = "ENUM_#{code_ids.join '_'}"
  selclass = Object.const_set typename, Class.new(Selection)
  selclass.define_singleton_method(:ids) {code_ids}
  selclass.define_singleton_method(:scheme) {doc}
  selclass.define_singleton_method(:to_s) {"#{self.scheme}(#{self.ids.join(',')})"}
  return selclass
end
