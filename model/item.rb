require_relative '../src/data_model'
require_relative 'unit_reference_data'
require_relative 'item_reference_data'
require_relative 'party_reference_data'

domain :Items do

  datatype(:ItemType,
           description:
               "Defines the items that can be offered in any selected agreements" +
                   "Agreements hava a number of items that can have values defining the agreement. The Items should" +
                   "constrain the key quantifiable elements of an agreement award. A supplier may provide additional" +
                   "variable facts in their Offer to supplement the description of how they support the agreement.") {
    attribute :id, String, "The composite code string, which must be unique across all schemes" +
        "Make this up by taking the scheme_id and appending the code id"
    attribute :description, String, "long description"
    attribute :keyword, String, ZERO_TO_MANY, "alternate names for the item type"
    attribute :scheme_id, ALL_ITEM_SCHEMES, ONE_TO_MANY, "The classiciation scheme id, which links to an entry in item_classification_schemes",
              example: "CPV"
    attribute :code, String, ONE_TO_MANY, "Code within the primary scheme defining this type. Each code should have a prefix identifying the scheme",
              example: "CPV:37000000-8"
    attribute :unit_scheme, UNITS_SCHEMES, " define the unit scheme, from the schemes in unit_classification_schemes ",
              example: "QUDT"
    attribute :unit, String, "define the units, based on the unit scheme selected",
              example: "QUDT:unit:SquareMeterPerKelvin"
    attribute :sector_scheme, SECTOR_SCHEMES, ZERO_TO_MANY, "The sector scheme id", example: "ccsscheme"
    attribute :sector_id, String, ZERO_TO_MANY,
              "The sector scheme ids that define to whom the item may be sold. Prefix must match one of the schemes.",
              example: "ccsscheme:education_funded"
  }

  datatype(:Item,
           description: "Specifies the value of an item that is being offered for an agreement") {
    attribute :type_id, String, " type of the item ", links: Items::ItemType
    attribute :unit, String, " define the units, which should match one of the allowed unit code values" +
        "in the scheme defind in the type"
    attribute :value, Object, "an object of the type matching type->units"
  }

end