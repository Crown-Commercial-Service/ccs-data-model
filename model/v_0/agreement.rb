require_relative 'register'
require_relative 'item'
require_relative 'agreement_reference_data'
require_relative 'education_reference_data'

include DataModel

domain :Agreements do

  datatype(:Restriction, description: "a type with a number of classification attributes, such as sector, location") {
    attribute :sector_scheme, SECTOR_SCHEMES, ZERO_TO_MANY, "The sector scheme id", example: CCSSECTORS.url
    attribute :sector_id, String, ZERO_TO_MANY,
              "The sector scheme ids that define to whom the item may be sold. Prefix must match one of the schemes.",
              example: "#{CCSSECTORS.id}:#{CCSSECTORS.id}"
    attribute :location_scheme, LOCATION_SCHEMES, ZERO_TO_MANY, "The schemes for identifying locations",
              example: "[#{NUTS.uri}]"
    attribute :location_id, String, ZERO_TO_MANY,
              "The location scheme ids that defines  where the items can be offered.",
              example: "[UKH1, UKG2]"
  }

  datatype(:Agreement, extends: Register::Record,
           description: "General definition of Commercial Agreements") {

    # identify the agreement
    attribute :kind, AGREEMENT_TYPES,
              "Kind of agreement, such as Framework, Lot,Contract. Lots are considered separate" +
                  "agreements, but link to their owning framework agreement. Similarly Contracts should link to any" +
                  "lot that they are based on. " +
                  "See #{AGREEMENT_TYPES.doc.url} for details.",
              example: FW.id
    attribute :id, String, "id of agreeement; This is the RM number for a framework, and {RM#lotnumber} for a lot",
              example: "#{CCS_FW_CODE.prefix}:RM3541"
    attribute :id_scheme, AGREEMENT_ID_SCHEMES, SINGLE, "who to identify the agreement", example: CCS_FW_CODE.uri

    attribute :keyword, String, ZERO_TO_MANY, "other names for the agreement"
    attribute :name, String, example: "Supply Teachers"
    attribute :long_name, String, example: "Supply Teachers Framework 2018"
    attribute :status, AGREEMENT_STATUSES, SINGLE,
              "current status of agreement" +
                  "See #{AGREEMENT_STATUSES.doc.url} for details."

    attribute :description, String, "Describe the agreement"

    attribute :start_date, Date
    attribute :end_date, Date
    attribute :duration, Integer, "Months"

    attribute :original_end_date, Date
    attribute :pillar, String
    attribute :category, String

    attribute :restriction, :Restriction, ZERO_OR_ONE, "Restrictions that may apply"

    # structure of agreement
    attribute :part_of_id, String, "Agreement this is part of, applicable only to Lots", links: :Agreement
    attribute :conforms_to_id, String, "Agreement this conforms to, such as a Contract conforming to a Framework", links: :Agreement

    attribute :item_type, Items::ItemType, ZERO_TO_MANY,
              "describe the items that can be offered under the agreement"

    attribute :supplier_qualification_scheme, String, ZERO_TO_MANY,
              "schemes describing coding for suppliers qualification questionnaires",
              example: APPRENTICESHIP_QUALIFICATION.url

    # Qualifications
    attribute :min_value, Integer, ZERO_OR_ONE, "Minimum value of award, in pounds sterling"
    attribute :max_value, Integer, ZERO_OR_ONE, "Maximum value of award, in pounds sterling"

  }


end