
require_relative '../src/data_model'

ReferenceData.new :UserNeeds do
  USERNEEDS = codelist {
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

datatype(:ExpressionOfNeed,
         description:
             " Defines a buyer 's need which can be matched to agreement items and other details
The need matches closely to our definitions of agreements under ' items types ' and their classification
schemes, but is not a one-to-one match.") {
  attribute :buyer_id, String, "The buyer expressing the need"
  attribute :kind, Enum(USERNEEDS)
  attribute :value, String
  attribute :unit_scheme, ALL_UNITS_SCHEMES, "The units scheme "
  attribute :unit_scheme, String, "The units typically used to express the need"
}
