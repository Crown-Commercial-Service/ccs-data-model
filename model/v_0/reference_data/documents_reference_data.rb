require_relative '../reference_data'


ReferenceData.new :DocStorageCodes do
  DOC_STORAGE_TYPES = Enum(codelist {
    macro &ID_AND_URL_FROM_DOMAIN_AND_VERSION
    description "Where do we store the document"
    S3= code {
      id :s3
      macro &URI_FROM_DOC_AND_ID
      title "AWS S3 doc URI"
      description title
    }
    GDOC= code {
      id :gdoc
      macro &URI_FROM_DOC_AND_ID
      title "Google drive link"
      description title
    }
  }, code_type: :code, code_key: :id)

  DOC_ROLE_STANDARDS = Enum(standardlist {
    macro &ID_AND_URL_FROM_DOMAIN_AND_VERSION
    description "What is the purpose of the document. There will be many schemes based on questionnaires."
    EDUCATION_CERTIFICATES_AND_DOCUMENTS= standard {
      id :ed_doc
      macro &URI_FROM_DOC_AND_ID
      title "Education certificates and supporting documents"
      description title
      prefix id
      example "ed_doc:Certificate of Rating"
    }
    SIGNED_CONTRACTS= standard {
      id :contract_doc
      macro &URI_FROM_DOC_AND_ID
      title "Contracts"
      description title
      example "#{prefix}:signed_calloff"
    }
  })
end
