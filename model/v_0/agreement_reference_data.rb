require_relative 'reference_data'

ReferenceData.new :AgreementTypeCodes do
  AGREEMENT_TYPES = Enum(codelist {
    version "0.1.0"
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
  }, code_key: :id)
end

ReferenceData.new :AgreementIDScheme do
  AGREEMENT_ID_SCHEMES = Enum(scheme {
    version "0.1.0"
    macro &ID_AND_URL_FROM_DOMAIN_AND_VERSION
    prefix "ccs_atype"
    title "Agreement id schemes"
    description "Scheme for how to identify an agreement"
    FW = code {
      id :ccs_fw_id
      prefix :rm
      macro &URI_FROM_DOC_AND_ID
      title "Framework ID"
      example "#{prefix}:RM1234"
      source "Salesforce or Contracts Finder"
    }
    code {
      id :lot_number
      prefix :lot
      macro &URI_FROM_DOC_AND_ID
      title "Lot in Framework "
      description "Lot in Framework - form is {rm}\#{lot}"
      example "#{prefix}:RM1234#3"
      source "Salesforce or Contracts Finder"
    }
    code {
      id :cf_contract_id
      prefix :cf
      macro &URI_FROM_DOC_AND_ID
      title "Contract in ContractFinder"
      example "#{prefix}:Notice/891b4363-fcab-4a8b-a450-5bc886508641"
      source "ContractsFinder"
    }
  })
end

ReferenceData.new :AgreementStatusCodes do
  AGREEMENT_STATUSES = Enum(codelist {
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
  }, code_key: :id)
end
