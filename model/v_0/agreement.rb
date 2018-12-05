require_relative 'register'
require_relative 'item'
require_relative 'agreement_reference_data'
require_relative 'education_reference_data'

include DataModel

domain :Agreements do

  datatype(:Restriction, description: "a type with a number of classification attributes, such as sector, location") {
    attribute :sector_standard, SECTOR_STANDARDS, ZERO_TO_MANY, "The sector standard id", example: CCSSECTORS.url
    attribute :sector_id, String, ZERO_TO_MANY,
              "The sector standard ids that define to whom the item may be sold. Prefix must match one of the standards.",
              example: "#{ED.container.id}:#{ED.id}"
    attribute :location_standard, LOCATION_STANDARDS, ZERO_TO_MANY, "The standards for identifying locations",
              example: "[#{NUTS.uri}]"
    attribute :location_id, String, ZERO_TO_MANY,
              "The location standard ids that defines  where the items can be offered.",
              example: "UKH1"
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
    attribute :id_standard, AGREEMENT_ID_STANDARDS, SINGLE, "who to identify the agreement", example: CCS_FW_CODE.uri

    attribute :keyword, String, ZERO_TO_MANY, "other names for the agreement"
    attribute :name, String, example: "Supply Teachers"
    attribute :long_name, String, example: "Supply Teachers Framework 2018"
    attribute :status, AGREEMENT_STATUSES, SINGLE,
              "current status of agreement" +
                  "See #{AGREEMENT_STATUSES.doc.url} for details."

    attribute :description, String, "Describe the agreement"

    attribute :start_date, Date, example: "2019-01-01"
    attribute :end_date, Date, example: "2020-01-10"
    attribute :duration, Integer, "Months", example: 5

    attribute :org_structure_standard, ORG_STRUCT_STANDARDS, "Standard identifying prefixes for organisation responbsible for this agreement. ", example: CCS_ORG_CODES.url
    attribute :owning_org_unit_name, String, ONE_TO_MANY, "Commercial category org unit responsible for this agreement. Usually the CCS pillar name and a category name", example: "#{CCS_ORG_CODES.id}:#{BUILDINGS.id}"
=begin
    attribute :contact_standard, CONTACT_ID_STANDARDS, "The standard used to link to contacts in this agreement record. ", SINGLE, example: EMAIL.uri
=end
    attribute :owner_id, String, ONE_TO_MANY, "Individual accountable for the agreement", example: "#{EMAIL.id}example_owner@crowncommercial.gov.uk"

    attribute :restriction, :Restriction, ZERO_OR_ONE, "Restrictions that may apply, such as government sectors and locations. "

    # structure of agreement
    attribute :part_of_id, String, "Agreement this is part of; typically applicable only to *Lots*. ", links: :Agreement
    attribute :conforms_to_id, String, "Agreement this conforms to, such as a Contract conforming to a Framework", links: :Agreement

    attribute :item_type, Items::ItemType, ZERO_TO_MANY,
              "describe the items that can be offered under the agreement"

    attribute :min_value, Integer, ZERO_OR_ONE, "Minimum value of award, in pounds sterling"
    attribute :max_value, Integer, ZERO_OR_ONE, "Maximum value of award, in pounds sterling"

  }


end