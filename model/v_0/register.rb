require_relative '../../src/data_model'

include DataModel

domain :Register do

  datatype(:Record, description: "register versioned entry, such that all versions of an entity with the same type and id have uniqe identifiers") {

    attribute :version_id, String, "UUID of this version of the entry", example: "90ccab31-84fb-486c-84ba-77a66ff686ea"
    attribute :supercedes_id, String, "UUID of this version superceded", example: "e030f1b1-647d-4ed7-8d84-ac9790563362"
    attribute :date_added, DateTime, "Date of creation or update", example: "2019-09-28T18:34:23.45Z"
    attribute :checksum, String, "MD5", example: "90b4c251f8649a4f9c86d6d20ee6e9e9"
  }

end