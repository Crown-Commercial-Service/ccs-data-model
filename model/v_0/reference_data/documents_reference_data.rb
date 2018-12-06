require_relative '../reference_data'


ReferenceData.new :DocStandardCodes do
  DOC_STANDARDS = Enum( codelist {
    macro &ID_AND_URL_FROM_DOMAIN_AND_VERSION
    title "Contact id  Standards"
    description "How to identify a link to a contact"
    S3= code {
      id :s3
      macro &URI_FROM_DOC_AND_ID
      title "Google doc URI"
      description title
    }
    GDOC= code {
      id :gdoc
      macro &URI_FROM_DOC_AND_ID
      title "Google drive link"
      description title
    }
  }, code_type: :code, code_key: :id)
end
