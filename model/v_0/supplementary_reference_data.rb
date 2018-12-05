require_relative 'supplementary'

ReferenceData.new :SupplementaryDataTypeCodes do
  SUPPLEMENTARY_TYPE_CODES = Enum( codelist {
    macro &ID_AND_URL_FROM_DOMAIN_AND_VERSION
    title "SupplementaryDataType"
    description "Identify the types in supplementary data of a filter"
    STRING = code {
      id :string
      macro &URI_FROM_DOC_AND_ID
      title "string filter"
      description "supplementary is a unicode UTF8 encoded string of indeterminate lengh, but no more than 10k in size."
    }
    DATE = code {
      id :date
      macro &URI_FROM_DOC_AND_ID
      title "date filter"
      description "supplementary is a date in iso 860 format."
    }
    INT = code {
      id :int
      macro &URI_FROM_DOC_AND_ID
      title "integer filter"
      description "supplementary is a signed int in 64 bit range."
    }
    FLOAT = code {
      id :float
      macro &URI_FROM_DOC_AND_ID
      title "floating point numbner filter"
    }
  }, code_type: :code, code_key: :id)
end
