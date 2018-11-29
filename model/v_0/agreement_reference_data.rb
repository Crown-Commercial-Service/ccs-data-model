require_relative 'reference_data'

ReferenceData.new :AgreementTypeCodes do
  AGREEMENT_TYPES = Enum(codelist {
    version  "0.1.0"
    macro &ID_AND_URL_FROM_DOMAIN_AND_VERSION
    prefix "ccs_atype"
    title "Agreement types"
    description "Scheme of codes used to decide what scheme to use to classify an agreement"
    code {
      id :framework
      macro &URI_FROM_DOC_AND_ID
      title "Framework "
    }
    code {
      id :lot
      macro &URI_FROM_DOC_AND_ID
      title " Lot "
    }
    code {
      id :contract
      macro &URI_FROM_DOC_AND_ID
      title " Contract"
    }
  })
end

ReferenceData.new :AgreementStatusCodes do
  AGREEMENT_STATUSES = Enum (codelist {
    macro &ID_AND_URL_FROM_DOMAIN_AND_VERSION
    title "Agreement types"
    description "Scheme of codes used to decide what scheme to use to classify an agreement"
    code {
      id :live
      macro &URI_FROM_DOC_AND_ID
    }
    code {
      id :inactive
      macro &URI_FROM_DOC_AND_ID
    }
    code {
      id :future
      macro &URI_FROM_DOC_AND_ID
    }
    code {
      id :planned
      macro &URI_FROM_DOC_AND_ID
    }
    code {
      id :underway
      macro &URI_FROM_DOC_AND_ID
    }
    code {
      id :withdrawn
      macro &URI_FROM_DOC_AND_ID
    }
    code {
      id :ended
      macro &URI_FROM_DOC_AND_ID
    }
  })
end
