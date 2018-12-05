require_relative '../../src/data_model'
require_relative 'host'

include DataModel

domain :Register do

  datatype(:Record, description:
      "A register versioned records, such that all versions of an entity with the same type and id have unique identifiers. ") {

    attribute :version_id, String, "UUID of this version of the entry", example: "90ccab31-84fb-486c-84ba-77a66ff686ea"
    attribute :supercedes_id, String, ZERO_OR_ONE, "UUID of this version superceded. May be empty only if this is the  first version", example: "e030f1b1-647d-4ed7-8d84-ac9790563362"
    attribute :datetime, DateTime, "Date of creation or update of this record, date of creation of this version. ", example: "2019-09-28T18:34:23.45Z"
    attribute :checksum, String, "MD5 checksum of the record", example: "90b4c251f8649a4f9c86d6d20ee6e9e9"
    attribute :url, String, "URL which will retreive this version of the record", example: "#{API_HOST}/api/Agreement/rm-RM1234"
  }

end