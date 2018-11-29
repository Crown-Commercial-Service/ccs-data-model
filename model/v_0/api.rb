require_relative '../../src/data_model'
include DataModel

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

API_VERSION = Version.new "0.1.0"

API.new :API_V0_1 do
  endpoint {
    host "ccs.gov.uk"
    version API_VERSION
    resource {type Agreements::Agreement}
    resource {type Items::ItemType}
    resource {type Items::Item}
  }
end