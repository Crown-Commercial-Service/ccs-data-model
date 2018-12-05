require_relative '../../src/data_model'
require_relative 'agreement'
require_relative 'offering_reference_data'
require_relative 'education_reference_data'
require_relative 'party'
include DataModel

domain :Offerings do

  datatype(:Offering, extends: Register::Record,
           description: " Supplier offering against an item or items of an agreement." +
               "This may be extended for different agreements. A supplier may provide additional" +
               "variable facts in their Offer to supplement the description of how they support the agreement. ") {

    attribute :id, String, "unique uuid for the offering",
              example: "db1fa9ac-1b83-4c27-8c80-ded2f0120c54"

    attribute :agreement_id_scheme, AGREEMENT_ID_SCHEMES, SINGLE, "who to identify the agreement", example: CCS_FW_CODE.uri
    attribute :agreement_id, String, "The agreement this offering relates to", links: Agreements::Agreement

    attribute :supplier_id_scheme, ORG_ID_SCHEMES
    attribute :supplier_id, String, links: Parties::Party, example: "comphouse:12345678"

    attribute :name, String
    attribute :description, String
    attribute :item, Items::Item, ZERO_TO_MANY, "values for the items, matching the definitions in agreement->item_type"
    attribute :supplementary, Supplementary::Field, ZERO_TO_MANY,
              "Additional data used to qualify the offering over and above the item details. " +
                  "Supplementary data's role prefix should obviously be relevant to the item's schemes, meaning the supplementary prefix" +
                  "codes should match one of the schemes in `item->itemtype->classification|additional_classifications`.",
              example: "#{PROVIDER_OFFSTED.prefix}:#{START_DATE.id}"
    attribute :branch, String, ZERO_TO_MANY,
              "Id of contact point where the offering can occur; contact should include address details.", links: Parties::Contact
  }

  datatype(:Catalogue,
           description: " A collection of supplier offerings against an item, for an agreement ") {
    attribute :offers, :Offering, ZERO_TO_MANY, "description of the item"
  }
end