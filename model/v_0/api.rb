require_relative 'agreement'
require_relative 'offering'
require_relative 'party'

domain(:API) {

  datatype(:Resource, description: "
  Specify how to access a data type ") {
    attribute :type, DataType
  }

  datatype( :Endpoint, description: "end point for a number of resources"){
    attribute :host, String
    attribute :version, Version
    attribute :resource, :Resource, ZERO_TO_MANY
  }

}

API.new :API_V0_1 do
  endpoint {
    host API_HOST
    version VERSION
    resource {type Agreements::Agreement}
    resource {type Items::ItemType}
    resource {type Parties::Party}
    resource {type Parties::Contact}
    resource {type Parties::Questionnaire}
    resource {type Offerings::Offering}
  }
end