require_relative 'reference_data'
require_relative 'reference_data/supplementary_reference_data'
require_relative 'reference_data/education_reference_data'


domain :Supplementary do

  datatype(:Value,
           description: "A supplementary value which can be any one of the below types. Only one will be set.",
           union: true) {

    attribute :string, String,
              "UTF8 string",
              example: "Some text is here"
    attribute :date, Date,
              example: "2019-03-01"
    attribute :float, Float,
              example: "1.23"
    attribute :int, Integer,
              example: "123"
  }

  datatype(:Field, description: "an additional field that helps qualify the object") {
    attribute :role_id, String, "Standard uri code that defines the role of the supplementary field, which"+
        " should be prefixed by a standard id in the enclosing *Item type*, ", example: START_DATE.example
    attribute :type_id, SUPPLEMENTARY_TYPE_CODES, "Type of the field - which should be appropriate for the role. ",
              example: "string"
    attribute :value, :Value, "Supplementary data matching the type",
              example: "A descriptive string"
  }


end