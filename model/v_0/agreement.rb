require_relative '../../src/data_model'
require_relative 'item'
require_relative 'agreement_reference_data'

include DataModel

domain :Agreements do

  datatype(:Agreement,
           description: "General definition of Commercial Agreements") {

    # identify the agreement
    attribute :kind, AGREEMENT_TYPES,
              "Kind of agreement, such as Framework, Lot,Contract. Lots are considered separate" +
                  "agreements, but link to their owning framework agreement. Similarly Contracts should link to any" +
                  "lot that they are based on. " +
                  "See #{AGREEMENT_TYPES.doc.url} for details."
    attribute :id, String, "id of agreeement; This is the RM number for a framework, and {RM#lotnumber} for a lot",
              example: "#{FW.prefix}:RM3541"
    attribute :id_scheme, AGREEMENT_ID_SCHEMES, SINGLE, "who to identify the agreement", example: FW.uri
    # TODO add selection from agremment id schemes
    attribute :keyword, String, ZERO_TO_MANY, "other names for the agreement"
    attribute :name, String
    attribute :long_name, String
    attribute :version, String, "semantic version id of the agreement model, in the form X.Y.Z"
    attribute :status, AGREEMENT_STATUSES, SINGLE,
              "current status of agreement" +
                  "See #{AGREEMENT_STATUSES.doc.url} for details."
    attribute :pillar, String
    attribute :duration, Integer, "Months"
    attribute :category, String
    attribute :start_date, Date
    attribute :end_date, Date
    attribute :original_end_date, Date
    attribute :description, String, "Describe the agreement"

    # structure of agreement
    attribute :part_of_id, String, "Agreement this is part of, applicable only to Lots", links: :Agreement
    attribute :conforms_to_id, String, "Agreement this conforms to, such as a Contract conforming to a Framework", links: :Agreement

    attribute :item_type, Items::ItemType, ZERO_TO_MANY,
              "describe the items that can be offered under the agreement"

    # Qualifications
    attribute :min_value, Integer, ZERO_OR_ONE, "Minimum value of award, in pounds sterling"
    attribute :max_value, Integer, ZERO_OR_ONE, "Maximum value of award, in pounds sterling"

  }


end