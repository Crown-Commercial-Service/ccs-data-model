
require_relative '../../src/data_model'

ReferenceData.new :UserNeedCodes do
  USERNEEDS = codelist {
    macro &ID_AND_URL_FROM_DOMAIN_AND_VERSION
    title "Agreement types"
    description "Standard of codes used to decide what standard to use to classify an agreement"
    code {
      id :location
      macro &URI_FROM_DOC_AND_ID
      title "Location"
      description " Where is the need? " +
                      " Match location needs to locations of offers "
    }
    code {
      id :service
      macro &URI_FROM_DOC_AND_ID
      title "Service"
      description " What sort of things do they need? " +
                      " Match the service to item types, their keywords, and offering titles."
    }
    code {
      id :budget
      macro &URI_FROM_DOC_AND_ID
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
standards, but is not a one-to-one match.") {
  attribute :buyer_id, String, "The buyer expressing the need"
  attribute :kind, Enum(USERNEEDS)
  attribute :value, String
  attribute :unit_standard, UNITS_STANDARDS, "The units standard "
  attribute :unit_standard, String, "The units typically used to express the need"
}
