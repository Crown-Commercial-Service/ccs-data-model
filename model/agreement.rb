require_relative '../src/data_model'
require_relative 'party'
require_relative 'geographic'
require_relative 'reference_data'

include DataModel

def scheme_url(codelist)
  "reference.crowncommercial.gov.uk/#{codelist}"
end

ReferenceData.new :AgreementReferenceData do

  AGREEMENT_TYPES = codingscheme {
    id :AgreementTypes
    version "0.1.0"
    title "Agreement types"
    description "Scheme of codes used to decide what scheme to use to classify an agreement"
    code {
      id :Framework
      title "Framework "
    }
    code {
      id :Lot
      title " Lot "
    }
    code {
      id :Contract
      title " Contract"
    }
  }

  ItemClassificationSchemes = schemeofschemes {
    id :ItemClassificationSchemes
    version "0.1.0"
    title "ItemClassificationSchemes"
    description "Scheme of codes used to decide what scheme to use to classify an item"
    code {
      id :CPV
      title "EC Common Procurement Vocabulary"
      description "The Common Procurement Vocabulary is a standard adopted by the Commission of the European Community, and consisting of a main vocabulary for defining the subject of a contract, and a supplementary vocabulary for adding further qualitative information. The main vocabulary, identified in OCDS by the code CPV, is based on a tree structure comprising codes of up to 9 digits (an 8 digit code plus a check digit) associated with a wording that describes the type of supplies, works or services forming the subject of the contract. Codes may be provided with or without the check digit, and consuming applications should be aware of this when processing data with CPV codes.	"
      source "http://simap.europa.eu/codes-and-nomenclatures/codes-cpv/codes-cpv_en.htm"
    }
    code {
      id :CPVS
      title "EC Common Procurement Vocabulary - Supplementary Codelists"
      description "The Common Procurement Vocabulary is a standard adopted by the Commission of the European Community, and consisting of a main vocabulary for defining the subject of a contract, and a supplementary vocabulary for adding further qualitative information. The supplementary vocabulary, identified in OCDS by the code CPVS, is made up of an alphanumeric code with a corresponding wording allowing further details to be added regarding the specific nature or destination of the goods to be purchased.	"
      source "http://simap.europa.eu/codes-and-nomenclatures/codes-cpv/codes-cpv_en.htm"
    }
    code {
      id :GSIN
      title "Goods and Services Identification Number"
      description "The Canadian federal government uses Goods and Services Identification Number (GSIN) codes to identify generic product descriptions for its procurement activities. The full list is published and maintained at buyandsell.gc.ca	"
      source "https://buyandsell.gc.ca/procurement-data/goods-and-services-identification-number"
    }
    code {
      id :UNSPSC
      title "United Nations Standard Products and Services Code	"
      description "The United Nations Standard Products and Services Code (UNSPSC) is a hierarchical convention that is used to classify all products and services. Machine readable metadata for UNSPSC is not provided as open data: and so publishers should consider alternative classification schemes that do provide open data lookup tables wherever possible.	"
      source "http://www.unspsc.org/codeset-downloads"
    }
    code {
      id :CPC
      title "Central Product Classification	"
      description "The Central Product Classification (CPC) is a product classification for goods and services promulgated by the United Nations Statistical Commission. It is intended to be an international standard for organizing and analyzing data on industrial production, national accounts, trade and prices	"
      source "http://unstats.un.org/unsd/cr/registry/cpc-21.asp"
    }
  }

  UNITSCHEMES = schemeofschemes {
    id :ItemClassificationSchemes
    version "0.1.0"
    title "Units"
    description "Scheme of codes used to decide what scheme to use to classify units"
    code {
      id :UNCEFACT
      title "UN/CEFACT Recommendation 20"
      description ""
      source "http://tfig.unece.org/contents/recommendation-20.htm"
    }
    code {
      id :QUDT
      title "Quantities, Units, Dimensions and Data Types Ontologies"
      description "Use the [QUDT Code](http://www.qudt.org/qudt/owl/1.0.0/unit/Instances.html) value."
      source "http://www.qudt.org/qudt/owl/1.0.0/unit/Instances.html"
    }
  }
end

ReferenceData.new :UserNeeds do
  USERNEEDS = codingscheme {
    id :AgreementTypes
    version "0.1.0"
    title "Agreement types"
    description "Scheme of codes used to decide what scheme to use to classify an agreement"
    code {
      id :Location
      title "Location"
      description " Where is the need? " +
                      " Match location needs to locations of offers "
    }
    code {
      id :Service
      title "Service"
      description " What sort of things do they need? " +
                      " Match the service to item types, their keywords, and offering titles."
    }
    code {
      id :Budget
      title "Budget"
      description "What is the budget the buyer has for their need?" +
                      "Match the budget to the value range of the agreement, and the value range of supplier offers." +
                      "Matching the budget will probably require evaluation of offer prices."
    }
  }

end

domain :Agreements do

  UNIT_SCHENES_ENUM = Enum(UNITSCHEMES)
  datatype(:ItemType,
           description:
               "Defines the items that can be offered in any selected agreements
                Agreements hava a number of items that can have values defining the agreement. The Items should
                constrain the key quantifiable elements of an agreement award. A supplier may provide additional
                variable facts in their Offer to supplement the description of how they support the agreement.") {

    attribute :id, String, "The composite code string, which must be unique across all schemes" +
        "Make this up by taking the scheme_id and appending the code id"
    attribute :description, String, "long description"
    attribute :keyword, String, ZERO_TO_MANY, "alternate names for the item type"
    attribute :scheme_id, Enum(ItemClassificationSchemes), "The classiciation scheme id"
    attribute :code, String, " Code within the scheme defining this type"
    attribute :unit_scheme, UNIT_SCHENES_ENUM, " define the unit scheme "
    attribute :unit, String, " define the units, if one units matches "
  }

  datatype(:ExpressionOfNeed,
           description:
               " Defines a buyer 's need which can be matched to agreement items and other details
The need matches closely to our definitions of agreements under ' items types ' and their classification
schemes, but is not a one-to-one match.") {
    attribute :buyer_id, String, "The buyer expressing the need"
    attribute :kind, Enum(USERNEEDS)
    attribute :value, String
    attribute :unit_scheme, UNIT_SCHENES_ENUM, "The units scheme "
    attribute :unit_scheme, String, "The units typically used to express the need"
  }

  datatype(:Agreement,
           description: "General definition of Commercial Agreements") {

    # identify the agreement
    attribute :kind, Enum(AGREEMENT_TYPES),
              "Kind of agreement, such as Framework, Lot, Contract. Lots are considered separate
agreements, but link to their owning framework agreement. Similarly Contracts should link to any
lot that they are based on"
    attribute :id, String, "id of agreeement; This is the RM number for a framework, and {RM#lotnumber} for a lot",
              example: "RM3541"
    attribute :keyword, String, ZERO_TO_MANY, "other names for the agreement"
    attribute :name, String
    attribute :long_name, String
    attribute :version, String, "semantic version id of the agreement model, in the form X.Y.Z"
    attribute :status, Enum(:Live, :Inactive, :Future, :Planned, :Underway)
    attribute :pillar, String
    attribute :duration, Integer, "Months"
    attribute :category, String
    attribute :start_date, Date
    attribute :end_date, Date
    attribute :original_end_date, Date
    attribute :description, String, "Describe the agreement"
    attribute :offerType, String, "Name of the subclass of the Offering, supporting the Agreement"


    # structure of agreement
    attribute :part_of_id, String, "Agreement this is part of, applicable only to Lots", links: :Agreement
    attribute :conforms_to_id, String, "Agreement this conforms to, such as a Contract conforming to a Framework", links: :Agreement
    attribute :item_type, :ItemType, ZERO_TO_MANY,
              "describe the items that can be offered under the agreement"

    # Qualifications
    attribute :min_value, Integer, ZERO_OR_ONE, "Minimum value of award, in pounds sterling"
    attribute :max_value, Integer, ZERO_OR_ONE, "Maximum value of award, in pounds sterling"

  }

  datatype(:Item,
           description: "Specifies the value of an item that is being offered for an agreement") {
    attribute :type_id, String, " type of the item ", links: :ItemType
    attribute :unit, String, " define the units, which should match one of the allowed unit code values
in the scheme defind in the type"
    attribute :value, Object, "an object of the type matching type->units"
  }

  datatype(:Offering,
           description: " Supplier offering against an item or items of an agreement.
This may be extended for different agreements. A supplier may provide additional
variable facts in their Offer to supplement the description of how they support the agreement. ") {
    attribute :agreement_id, String, "The agreement this offering relates to", links: :Agreement
    attribute :supplier_id, String, links: Parties::Party
    attribute :id, String, "unique id for the offering across all offerings, suppliers and frameworks"
    attribute :name, String
    attribute :description, String
    attribute :item, :Item, ZERO_TO_MANY, "details of the item"
    # Qualifications
    attribute :location_id, String, ONE_TO_MANY,
              "Pick list of applicable regions. There must be at least one, even if it is just ' UK '",
              links: Geographic::AreaCode
    attribute :sector_id, String, ZERO_TO_MANY,
              "Pick list of applicable sectors.
If set offering is only to be shown to users proven to belong to the sectors given", links: Parties::Sector
  }

  datatype(:Catalogue,
           description: " A collection of supplier offerings against an item, for an agreement ") {
    attribute :offers, :Offering, ZERO_TO_MANY, "description of the item"
  }

  datatype(:Involvement,
           description: "Involvement relationship between a party and an agreement
Technology strategy documents call this type ' interest ' but perhaps this could
be confused with the accounting interest") {
    attribute :agreement_id, String, "The agreement this interest relates to", links: :Agreement
    attribute :party_id, String, "The party this interest relates to", links: Parties::Party
    attribute :role, Enum(:AwardedSupplier, :AwardedBuyer, :SupplyingQuote, :RequestingQuote, :Etc),
              "The role of the party in the involvment"
  }

end