require_relative '../src/data_model'
include DataModel

domain(:API) {

  datatype(:Resource, description: "
  Specify how to access a data type ") {
    attribute :type, DataType
  }

  datatype( :Endpoint, description: "end point for a number of resources"){
    attribute :host, String
    attribute :version, String
    attribute :resource, :Resource, ZERO_TO_MANY
  }

}

