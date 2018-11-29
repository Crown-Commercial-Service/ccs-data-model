require_relative 'reference_data'

ReferenceData.new :AgreementTypes do
  AGREEMENT_TYPES = Enum(codelist {
    name :agreement_types
    prefix "ccs_atype"
    url ""
    version "0.1.0"
    title "Agreement types"
    description "Scheme of codes used to decide what scheme to use to classify an agreement"
    code {
      id :Framework
      title "Framework "
    }
    code {
      id :Lot
      title " Lot "
    }
    code {
      id :Contract
      title " Contract"
    }
  })
end

ReferenceData.new :AgreementStatuses do
  AGREEMENT_STATUSES = Enum (codelist {
    name :agreement_statuses
    version "0.1.0"
    title "Agreement types"
    description "Scheme of codes used to decide what scheme to use to classify an agreement"
    code {
      id :Live
    }
    code {
      id :Inactive
    }
    code {
      id :Future
    }
    code {
      id :Planned
    }
    code {
      id :Underway
    }
    code {
      id :Withdrawn
    }
    code {
      id :Ended
    }
  })
end
