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
               "Defines the items that can be offered in any selected agreements" +
                   "Agreements hava a number of items that can have values defining the agreement. The Items should" +
                   "constrain the key quantifiable elements of an agreement award. A supplier may provide additional" +
                   "variable facts in their Offer to supplement the description of how they support the agreement.") {
    attribute :id, String, "The composite code string, which must be unique across all schemes" +
        "This should be prefixed tith ethe primary classification code",
              example: "CPV:37000000-8:CCS:2019-01:1"
    attribute :description, String, "long description"
    attribute :keyword, String, ZERO_TO_MANY, "alternate names for the item type"
    attribute :classification_scheme, ITEM_SCHEMES, SINGLE,
              "The classiciation scheme id, which links to an entry in item_classification_schemes" +
                  "the item's id must be prefixed correctly for the classification, and be unique",
              example: CPV.uri
    attribute :classification, String, "Code within the primary scheme defining this type. Each code should have a prefix identifying the scheme",
              example: "CPV:37000000-8"
    attribute :additional_classification_schemes, ITEM_SCHEMES, ZERO_TO_MANY,
              "Additional ways to classify the item",
              example: "#{COURSE_DATA.url}"
    attribute :additional_classifications, String, ZERO_TO_MANY, "Code within the primary scheme defining this type. Each code should have a prefix identifying the scheme",
              example: "CPV:37000000-8"
    attribute :unit_scheme, UNITS_SCHEMES, ZERO_OR_ONE, " define the unit scheme, from the schemes in unit_classification_schemes ",
              example: QUDT.uri
    attribute :unit, String, "define the units, based on the unit scheme selected",
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
              "additional filters used to qualify the item. The supplementary types' codes should be prefixed to match one of the " +
                  "classification schemes in the item type"
  }

end