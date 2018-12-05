require_relative 'reference_data'

ReferenceData.new :AgreementTypeCodes do
  AGREEMENT_TYPES = Enum( codelist {
    version "0.1.0"
    macro &ID_AND_URL_FROM_DOMAIN_AND_VERSION
    title "Agreement types"
    description "Standard of codes used to decide what standard to use to classify an agreement"
    FW = code {
      id :framework
      macro &URI_FROM_DOC_AND_ID
      title "Framework "
    }
    LOT = code {
      id :lot
      macro &URI_FROM_DOC_AND_ID
      title " Lot "
    }
    CALLOFF = code {
      id :callof
      macro &URI_FROM_DOC_AND_ID
      title " Calloff"
    }
    CONTRACT = code {
      id :contract
      macro &URI_FROM_DOC_AND_ID
      title " Contract"
    }
  }, code_type: :code)
end

ReferenceData.new :AgreementIDStandard do
  AGREEMENT_ID_STANDARDS = Enum(standard {
    version "0.1.0"
    macro &ID_AND_URL_FROM_DOMAIN_AND_VERSION
    title "Agreement id standards"
    description "Standard for how to identify an agreement"
    CCS_FW_CODE = ref {
      id :ccs_fw_id
      prefix :rm
      macro &URI_FROM_DOC_AND_ID
      title "Framework ID"
      example "#{prefix}:RM1234"
      source "Salesforce or Contracts Finder"
    }
    ref {
      id :lot_number
      prefix :lot
      macro &URI_FROM_DOC_AND_ID
      title "Lot in Framework "
      description "Lot in Framework - form is {rm}\#{lot}"
      example "#{prefix}:RM1234#3"
      source "Salesforce or Contracts Finder"
    }
    ref {
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
    description "Standard of codes used to decide what standard to use to classify an agreement"
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
  }, code_type: :code, code_key: :id)
end
