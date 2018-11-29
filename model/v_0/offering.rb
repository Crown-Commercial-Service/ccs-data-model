require_relative '../../src/data_model'
require_relative 'agreement'
require_relative 'party'
include DataModel

domain :Offerings do

  datatype(:Offering,
           description: " Supplier offering against an item or items of an agreement." +
               "This may be extended for different agreements. A supplier may provide additional" +
               "variable facts in their Offer to supplement the description of how they support the agreement. ") {
    attribute :agreement_id, String, "The agreement this offering relates to", links: Agreements::Agreement
    attribute :supplier_id, String, links: Parties::Party
    attribute :id, String, "unique id for the offering across all offerings, suppliers and frameworks"
    attribute :name, String
    attribute :description, String
    attribute :item, Items::Item, ZERO_TO_MANY, "details of the item"
    # Qualifications
    # attribute :location_id, String, ONE_TO_MANY,
    #           "Pick list of applicable regions. There must be at least one, even if it is just ' UK '",
    #           links: Geographic::AreaCode
    # attribute :sector_code, String, ZERO_TO_MANY,
    #           "Pick list of applicable sectors If set offering is only to be shown to users proven to belong to the sectors given" +
    #               "sector code must be one of the codes in the Item's sector restrictions",
    #           links: Parties::Sector
  }

  datatype(:Catalogue,
           description: " A collection of supplier offerings against an item, for an agreement ") {
    attribute :offers, :Offering, ZERO_TO_MANY, "description of the item"
  }
end