require_relative '../../src/data_model'
require_relative 'host'
include DataModel

def ref_url id, version
  "#{REFERENCE_HOST}/v#{version.major}/#{id}#{REFERENCE_DOC_EXT}"
end

URI_FROM_DOC_AND_ID = lambda do
  uri "#{self.container.url}##{id.to_s.downcase}"
end

ID_AND_URL_FROM_DOMAIN_AND_VERSION = lambda do
  id snake_case(domain.name)
  title snake_case(domain.name)
  version VERSION
  url ref_url(id, version)
end

ONE_CONTAINER_TYPE = lambda do
  if domain.types.length > 0
    # raise "#{name} should have one top level type only to produce clead document"
  end
end

# point an entry in a standard to a code listed elsewhere
def link_standard_from_code(to, from)
  to.source = from.container.url
  to.id = from.id
  to.uri = from.uri
  to.prefix = from.container.id
  to.title = from.title
  to.description = from.description
  to.pattern = from.pattern
end

def link_standard_from_codelist(to, from)
  to.source = from.url
  to.id = from.id
  to.uri = from.url
  to.prefix = from.id
  to.title = from.title
  to.description = from.description
end

domain :ReferenceData do

  datatype(:Code) {
    attribute :id, String, "short code unique within the Code's standard" +
        "this should be prefixed with the prefix code of the associated DataDocument," +
        " forming a [curie](https://www.w3.org/TR/curie/#sec_2.1.)" +
        "the prefix is matched to the URL of the reference document, and the second part" +
        "of the code becomes an extension of the base url to allow the individial value to be found",
              example: "standard_prefix:item_code"
    attribute :title, String, ZERO_OR_ONE, "short name for the entry"
    attribute :description, String, ZERO_OR_ONE, "description on what the entry is for"
    attribute :uri, String, "resolved uri of the entry, used for selecting the entry in docs, and referring to it long form"
    attribute :pattern, String, "optional regular expression to check ids against."
    # attribute :expected_type, SUPPLEMENTARY_TYPE_CODES, "optional id of supplementary type, which should match the type of the item or other context."+
    # "Many id objects don't have values and so shouldn't have a type."
    attribute :example, String, "example of the value"
  }

  datatype(:Standard, extends: :Code, description: "A code which refers to a definition document, that describes another CodeList") {
    attribute :source, String, "a description or url for how to build codes against this standard"
    attribute :prefix, String, "A prefix code for building codes from this source. " +
        " If the referred standard has a good unique prefix that should be used, where as if it is unclear " +
        " a prefix should be defined so that coded IDs are not ambiguous in terms of format or origin." +
        "if there is one", example: "companies-house"
  }

  datatype(:DataDocument,
           description: "A data document is a static versioned set of code values used to classify other dynamic elements." +
               "For example, a list of status codes that an Agreement can be in.") {
    EXNAME = "item_classification_standards"
    attribute :url, String, "the URL of the data document", example: ref_url("#{EXNAME}", Version.new("1.1.0"))
    attribute :id, String, "name of document", example: "#{EXNAME}"
    attribute :title, String, "short document title for listing and web tabs"
    attribute :version, Version
    attribute :description, String, ZERO_OR_ONE
  }

  datatype(:StandardList, extends: :DataDocument,
           description: "A standard is a list of coded values where each value points to another code list") {
    attribute :standard, :Standard, ZERO_TO_MANY
  }

  datatype(:CodeList, extends: :DataDocument,
           description: "A standard is a list of coded values where each value points to another code list") {
    attribute :code, :Code, ZERO_TO_MANY
  }

end


