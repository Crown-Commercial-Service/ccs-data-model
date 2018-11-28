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


