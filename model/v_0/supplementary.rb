require_relative 'reference_data'
require_relative 'supplementary_reference_data'


domain :Supplementary do

  datatype(:Value,
           description: "A supplementary value which can be any one of the below types. Only one will be set.",
           union: true) {
    attribute :string, String, SINGLE,
              "UTF8 string",
              example: "Some text is here"
    attribute :date, Date, SINGLE,
              example: "2019-03-01"
    attribute :float, Float,
              example: "1.23"
    attribute :int, Integer,
              example: "123"
  }

  datatype(:Field, description: "an additional field that helps qualify the object") {
    attribute :id, String
    attribute :role_id, String, "Scheme uri code taht defines the role of the supplementary field, which"+
        " should be prefixed by a scheme id in the enclosing type", example: "educ"
    attribute :type_scheme, SUPPLEMENTARY_TYPE_CODES, "type scheme should be appropriate for the filter scheme",
              example: STRING
    attribute :value, :Value, "Supplementary data matching the type",
              example: "A descriptive string"
  }


end