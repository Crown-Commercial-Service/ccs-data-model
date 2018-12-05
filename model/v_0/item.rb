require_relative 'register'
require_relative 'unit_reference_data'
require_relative 'item_reference_data'
require_relative 'supplementary'
require_relative 'party_reference_data'
require_relative 'geographic_reference_data'
require_relative 'education_reference_data'

domain :Items do

  datatype(:ItemType, extends: Register::Record,
           description:
               "Defines the items that can be offered in certain agreements. " +
                   "*Agreement*s can have a number of items that can have values detailing  the agreement. The Items should" +
                   "constrain the key quantifiable elements of an agreement award, as defined by a supplier's offering against that agreement.") {

    attribute :id, String, "The composite code string which identifies this item, which must be unique across all schemes. " +
        "This should be prefixed with the primary *classification_scheme* code",
              example: "CPV:37000000-8:CCS:2019-01:1"
    attribute :name, String, "a short name to help understand the item"
    attribute :description, String, "long description of the item, which should match item descriptions in it's specification."
    attribute :keyword, String, ZERO_TO_MANY, "alternate names for the item type, which may help to find it."
    attribute :classification_scheme, ITEM_SCHEMES, SINGLE,
              "The classiciation scheme id, which links to an entry in #{ITEM_SCHEMES.doc.url}. " +
                  "The item's id must be prefixed correctly for the classification, and be unique.",
              example: CPV.uri
    attribute :classification, String,
              "Code within the primary scheme defining this type. Each code should have a prefix as defined in *classification_scheme*. ",
              example: "CPV:37000000-8"
    attribute :supplementary_classification_schemes, ITEM_SCHEMES, ZERO_TO_MANY,
              "Additional ways to classify the item, which may also provide schemes for supplementary data in offerings. ",
              example: "#{COURSE_DATA.url}"
    attribute :additional_classifications, String, ZERO_TO_MANY,
              "Code within the primary scheme defining this type. Each code should have a prefix identifying the scheme",
              example: "CPV:37000000-8"
    attribute :unit_scheme, UNITS_SCHEMES, ZERO_OR_ONE, "Define the unit scheme, from the schemes in #{UNITS_SCHEMES.doc.url} ",
              example: QUDT.uri
    attribute :unit, String, "Define the units used to quantify the item, based on the unit scheme selected. ",
              example: "#{QUDT.id}:unit:SquareMeterPerKelvin"
    attribute :currency, String, ZERO_OR_ONE,
              "define the currency of the per-unit-price, as ISO 4217 currency code. If absent, presume GDP,",
              example: "GBP"
  }

  datatype(:Item, extends: Register::Record,
           description: "Specifies the value of an item that is being offered for an agreement." +
               " All the data should be constrained according to the Item type in question") {
    attribute :id, String, " a generated UUID minted for this item ", example: "07719842-a3a1-41c5-8320-6439295fb90e"
    attribute :item_type_id, String, " type of the item ", links: Items::ItemType, example: "CPV:37000000-8:CCS:2019-01:1"
    attribute :unit_quantity, String, ZERO_OR_ONE, " define the units, which should match one of the allowed unit code values" +
        "in the scheme defind in the type", example: "100"
    attribute :unit_price, Float, ZERO_OR_ONE, "an number giving the price per unit as dictated by item_type->unit", example: 110
    attribute :supplementary, Supplementary::Field, ZERO_TO_MANY,
              "supplementary data used to qualify the item. The supplementary fields *role_id* should be prefixed to match one of the " +
                  "classification schemes in the item type"
  }

end