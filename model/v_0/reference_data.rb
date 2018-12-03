require_relative '../../src/data_model'
require_relative 'host'
include DataModel

def ref_url id, version
  "#{REFERENCE_HOST}/v#{version.major}/#{id}"
end

URI_FROM_DOC_AND_ID = lambda do
  uri "#{self.container.url}##{id.to_s.downcase}"
end

ID_AND_URL_FROM_DOMAIN_AND_VERSION = lambda do
  id snake_case(domain.name)
  version VERSION
  url ref_url(id, version)
end

ONE_CONTAINER_TYPE = lambda do
  if domain.types.length > 0
    # raise "#{name} should have one top level type only to produce clead document"
  end
end

domain :ReferenceData do

  datatype(:Code) {
    attribute :id, String, "short code unique within the Code's scheme" +
        "this should be prefixed with the prefix code of the associated DataDocument," +
        " forming a [curie](https://en.wikipedia.org/wiki/CURIE)" +
        "the prefix is matched to the URL of the reference document, and the second part" +
        "of the code becomes an extension of the base url to allow the individial value to be found",
              example: "sector:local_gov/social_care"
    attribute :title, String, ZERO_OR_ONE
    attribute :description, String, ZERO_OR_ONE
    attribute :uri, String, "resolved uri of the code, used for selecting scheme entries"
    attribute :pattern, String, "optional regular expression to check codes against. Should match the appropriate prefix form."
    attribute :example, String, "example of the value"
  }

  datatype(:SchemeCode, extends: :Code, description: "A code which refers to a definition document, that describes another CodeList") {
    attribute :source, String, "a description or url for how to build codes against this scheme"
    attribute :prefix, String, "A prefix code for building codes from this source. " +
        " If the referred standard has a good unique prefix that should be used, where as if it is ambiguous" +
        " onse should be created so that coded IDs are not ambiguous in terms of format or origin." +
        "if there is one", example: "companies-house"
  }

  datatype(:DataDocument,
           description: "A data document is a static versioned set of code values used to classify other dynamic elements." +
               "For example, a list of status codes that an Agreement can be in.") {
    EXNAME = "item_classification_schemes"
    attribute :url, String, "the URL of the data document", example: ref_url("#{EXNAME}", Version.new("1.1.0"))
    attribute :id, String, "name of document", example: "#{EXNAME}"
    attribute :title, String, "short document title for listing and web tabs"
    attribute :version, Version
    attribute :prefix, String,
              "A code used as a prefix for all codes in the document. This is should used instead of the document URL" +
                  "when creating codes ",
              example: "ccv"
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


