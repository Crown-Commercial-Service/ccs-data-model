require_relative '../src/data_model'
include DataModel

REFERENCE_HOST = "reference.services.crowncommercial.gov.uk"

def ref_url id
  "#{REFERENCE_HOST}/#{id}"
end

domain :ReferenceData do

  datatype(:Code) {
    attribute :id, String, "short code unique within the Code's scheme"+
    "this should be prefixed with the prefix code of the associated DataDocument,"+
        " forming a [curie](https://en.wikipedia.org/wiki/CURIE)"+
        "the prefix is matched to the URL of the reference document, and the second part"+
        "of the code becomes an extension of the base url to allow the individial value to be found",
              example: "sector:local_gov/social_care"
    attribute :title, String, ZERO_OR_ONE
    attribute :description, String, ZERO_OR_ONE
  }

  datatype(:SchemeCode, extends: :Code, description: "A code which refers to a definition document, that describes another CodeList") {
    attribute :source, String
    attribute :uri, String, "resolved uri of the code, used for selecting scheme entries"
  }

  datatype(:DataDocument,
           description: "A data document is a static versioned set of code values used to classify other dynamic elements."+
           "For example, a list of status codes that an Agreement can be in.") {
    EXNAME = "item_classification_schemes"
    attribute :url, String, "the URL of the data document", example: ref_url("#{EXNAME}")
    attribute :name, String, "name of document",example: "#{EXNAME}"
              attribute :title, String, "short document title for listing and web tabs"
    attribute :version, String
    attribute :prefix, String, "A code used as a prefix for all codes", example: "ccv"
    attribute :description, String, ZERO_OR_ONE
  }

  datatype(:Scheme, extends: :DataDocument,
           description: "A scheme is a list of coded values where each value points to another code list") {
    attribute :code, :SchemeCode, ZERO_TO_MANY
  }

  datatype(:CodeList, extends: :DataDocument,
           description: "A scheme is a list of coded values where each value points to another code list") {
    attribute :code, :Code, ZERO_TO_MANY
  }

end


