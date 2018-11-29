require_relative 'agreement'

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
    host "ccs.gov.uk"
    version VERSION
    resource {type Agreements::Agreement}
    resource {type Items::ItemType}
    resource {type Items::Item}
  }
end