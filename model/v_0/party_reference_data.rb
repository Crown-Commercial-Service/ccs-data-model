require_relative 'reference_data'

ReferenceData.new :CCSSectorCodes do
  CCSSECTORS= codelist {
    macro &ID_AND_URL_FROM_DOMAIN_AND_VERSION
    title "CCS Sector Classification Schemes"
    description "Scheme of codes used to decide what scheme to use to classify an item"
    prefix "ccs_sector"
    code {
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
    prefix "sectorscheme"
    code {
      id :ccs
      macro &URI_FROM_DOC_AND_ID
      title "CCS sector coding"
      description "CCS defined sector coding"
      source CCSSECTORS.url
    }
  })
end


ReferenceData.new :QualificationScheme do
  QUALIFICATION_SCHEMES = Enum (scheme {
    macro &ID_AND_URL_FROM_DOMAIN_AND_VERSION
    title "Qualification Classification Schemes"
    description "Scheme of codes used to decide what scheme to use to classify an item"
    prefix "qualscheme"
    OFFSTED= code {
      id :offsted_rating
      prefix id
      macro &URI_FROM_DOC_AND_ID
      title "Offsted Rating"
      description title
      source "Offsted codes TBD"
    }
  })
end


ReferenceData.new :OrgIdScheme do
  ORG_ID_SCHEMES = Enum (scheme {
    macro &ID_AND_URL_FROM_DOMAIN_AND_VERSION
    title "Organisation id Classification Schemes"
    description "Scheme of codes used to decide what scheme to use to classify an item"
    prefix "org_id"
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
    prefix "org_id"
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
