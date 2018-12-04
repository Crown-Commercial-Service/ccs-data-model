require_relative 'reference_data'

ReferenceData.new :CCSSectorCodes do
  CCSSECTORS= codelist {
    macro &ID_AND_URL_FROM_DOMAIN_AND_VERSION
    title "CCS Sector Classification Schemes"
    description "Scheme of codes used to decide what scheme to use to classify an item"
    ED= code {
      id :education_funded
      macro &URI_FROM_DOC_AND_ID
      title "ccs eduction funded"
      description "CCS sector coding for education appropriate for education frameworks."+
          "value should be education_funded:true or education_funded:false"
    }
  }
end

ReferenceData.new :SectorScheme do
  SECTOR_SCHEMES = Enum (scheme {
    macro &ID_AND_URL_FROM_DOMAIN_AND_VERSION
    title "Sector Classification Schemes"
    description "Scheme of codes used to decide what scheme to use to classify an item"
    code {
      link_scheme_from_scheme( self, CCSSECTORS)
    }
    code {
      id :other
      macro &URI_FROM_DOC_AND_ID
      prefix :other
      title "Other sector coding"
      description "Other / unknown sector coding scheme"
      source "none"
    }
  })
end



ReferenceData.new :OrgIdScheme do
  ORG_ID_SCHEMES = Enum (scheme {
    macro &ID_AND_URL_FROM_DOMAIN_AND_VERSION
    title "Organisation id Classification Schemes"
    description "Scheme of codes used to decide what scheme to use to classify an item"
    code {
      id :sf_org_id
      macro &URI_FROM_DOC_AND_ID
      title "CCS Salesforce id"
      description title
      source "CCS Salesforce"
      prefix id
    }
    code {
      id :companies_house
      macro &URI_FROM_DOC_AND_ID
      title "Companies House"
      description title
      source "Use CH register"
      prefix id
    }
    code {
      id :dun
      macro &URI_FROM_DOC_AND_ID
      title "Dun & Bradstreet"
      description title
      source "Use D&B register"
      prefix id
    }
    code {
      id :dfe
      macro &URI_FROM_DOC_AND_ID
      title "DfE"
      description title
      source "Use DfE&B register"
      prefix id
    }
  })
end

ReferenceData.new :ContactIdScheme do
  CONTACT_ID_SCHEMES = Enum (scheme {
    macro &ID_AND_URL_FROM_DOMAIN_AND_VERSION
    title "Contact id  Schemes"
    description "How to identify a link to a contact"
    SF_CONTACT= code {
      id :sf_contact
      macro &URI_FROM_DOC_AND_ID
      title "CCS Salesforce id"
      description title
      source "CCS Salesforce"
    }
    EMAIL= code {
      id :email
      macro &URI_FROM_DOC_AND_ID
      title "CCS Salesforce id"
      description title
      source "CCS Salesforce"
    }
  })
end

ReferenceData.new :ContactRoles do
  CONTACT_ROLES= Enum( codelist {
    macro &ID_AND_URL_FROM_DOMAIN_AND_VERSION
    title "Contact Roles"
    description " To be verified"
    code {
      id :org_administrator
      macro &URI_FROM_DOC_AND_ID
      title id
      description id
    }
    code {
      id :ccs_admin
      macro &URI_FROM_DOC_AND_ID
      title id
      description id
    }
    code {
      id :commercial_contact
      macro &URI_FROM_DOC_AND_ID
      title id
      description id
    }
  })
end
