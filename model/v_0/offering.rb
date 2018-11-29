require_relative '../../src/data_model'
require_relative 'agreement'
require_relative 'offering_reference_data'
require_relative 'party'
include DataModel

domain :Offerings do

  datatype(:FilterCode, description: "additional fields that help qualify the object"+
           "filter coded items are completely described by their filter value according to the scheme" +
           "the full detail of the filter should be included in the coding suffix"){
    attribute :id, String
    attribute :filter_scheme, FILTER_SCHEMES
  }

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
    attribute :filter, :FilterCode, ZERO_TO_MANY, "filters for the offer"
    attribute :branch, String, ZERO_TO_MANY, "where the offering can occur; contact should include address details", links: Parties::Contact
  }

  datatype(:Catalogue,
           description: " A collection of supplier offerings against an item, for an agreement ") {
    attribute :offers, :Offering, ZERO_TO_MANY, "description of the item"
  }
end