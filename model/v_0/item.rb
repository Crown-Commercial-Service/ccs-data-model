require_relative 'register'
require_relative 'reference_data/unit_reference_data'
require_relative 'reference_data/item_reference_data'
require_relative 'supplementary'
require_relative 'reference_data/party_reference_data'
require_relative 'reference_data/geographic_reference_data'
require_relative 'reference_data/education_reference_data'

domain :Items do

  datatype(:ItemType, extends: Register::Record,
           description:
               "Defines the items that can be offered in certain agreements. " +
                   "*Agreement*s can have a number of items that can have values detailing  the agreement. The Items should" +
                   "constrain the key quantifiable elements of an agreement award, as defined by a supplier's offering against that agreement.") {

    attribute :id, String, "The composite code string which identifies this item, which must be unique across all standards. " +
        "This should be prefixed with the primary *classification_standard* code",
              example: "CPV:37000000-8:CCS:2019-01:1"
    attribute :name, String, "a short name to help understand the item"
    attribute :description, String, "long description of the item, which should match item descriptions in it's specification."
    attribute :keyword, String, ZERO_TO_MANY, "alternate names for the item type, which may help to find it."
    attribute :classification_standard, ITEM_STANDARDS, SINGLE,
              "The classiciation standard id, which links to an entry in #{ITEM_STANDARDS.doc.url}. " +
                  "The item's id must be prefixed correctly for the classification, and be unique.",
              example: CPV.uri
    attribute :classification, String,
              "Code within the primary standard defining this type. Each code should have a prefix as defined in *classification_standard*. ",
              example: "CPV:37000000-8"
    attribute :supplementary_classification_standards, ITEM_STANDARDS, ZERO_TO_MANY,
              "Additional ways to classify the item, which may also provide standards for supplementary data in offerings. ",
              example: "#{COURSE_DATA.url}"
    attribute :additional_classifications, String, ZERO_TO_MANY,
              "Code within the primary standard defining this type. Each code should have a prefix identifying the standard",
              example: "CPV:37000000-8"
    attribute :unit_standard, UNITS_STANDARDS, ZERO_OR_ONE, "Define the unit standard, from the standards in #{UNITS_STANDARDS.doc.url} ",
              example: QUDT.uri
    attribute :unit, String, "Define the units used to quantify the item, based on the unit standard selected. ",
              example: "#{QUDT.id}:unit:SquareMeterPerKelvin"
    attribute :currency, String, ZERO_OR_ONE,
              "define the currency of the per-unit-price, as ISO 4217 currency code. If absent, presume GDP,",
              example: "GBP"
    attribute :supplier_qualification_standard, String, ZERO_TO_MANY,
              "standards describing qualifications required by suppliers in order to offer solutions against this item. ",
              example: APPRENTICESHIP_QUALIFICATION.url
  }

  datatype(:Item, extends: Register::Record,
           description: "Specifies the value of an item that is being offered for an agreement." +
               " All the data should be constrained according to the Item type in question") {
    attribute :id, String, " a generated UUID minted for this item ", example: "07719842-a3a1-41c5-8320-6439295fb90e"
    attribute :item_type_id, String, " type of the item ", links: Items::ItemType, example: "CPV:37000000-8:CCS:2019-01:1"
    attribute :unit_quantity, String, ZERO_OR_ONE, " define the units, which should match one of the allowed unit code values" +
        "in the standard defind in the type", example: "100"
    attribute :unit_price, Float, ZERO_OR_ONE, "an number giving the price per unit as dictated by item_type->unit", example: 110
    attribute :supplementary, Supplementary::Field, ZERO_TO_MANY,
              "supplementary data used to qualify the item. The supplementary fields *role_id* should be prefixed to match one of the " +
                  "classification standards in the item type"
  }

end