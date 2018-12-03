require_relative '../../src/data_model'
require_relative 'agreement'
require_relative 'offering_reference_data'
require_relative 'education_reference_data'
require_relative 'party'
include DataModel

domain :Offerings do


  datatype(:Offering, extends: Items::Classified,
           description: " Supplier offering against an item or items of an agreement." +
               "This may be extended for different agreements. A supplier may provide additional" +
               "variable facts in their Offer to supplement the description of how they support the agreement. ") {
    #TODO agreement id scheme
    attribute :agreement_id, String, "The agreement this offering relates to", links: Agreements::Agreement
    #TODO supplier id scheme
    attribute :supplier_id, String, links: Parties::Party, example: "comphouse:12345678"
    attribute :id, String, "unique id for the offering across all offerings, suppliers and frameworks"
    attribute :name, String
    attribute :description, String
    attribute :item, Items::Item, ZERO_TO_MANY, "values for the items"
    attribute :supplementary, Supplementary::Field, ZERO_TO_MANY,
              "additional filters used to qulify the offering. Filter schemes should obviously be relevant to the item's schemes",
              example: "#{PROVIDER_OFFSTED.prefix}:#{START_DATE.id}"
    attribute :branch, String, ZERO_TO_MANY, "where the offering can occur; contact should include address details", links: Parties::Contact
  }

  datatype(:Catalogue,
           description: " A collection of supplier offerings against an item, for an agreement ") {
    attribute :offers, :Offering, ZERO_TO_MANY, "description of the item"
  }
end