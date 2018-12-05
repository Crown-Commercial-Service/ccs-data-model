require_relative 'reference_data'

ReferenceData.new :CCSSectorCodes do
  CCSSECTORS= codelist {
    macro &ID_AND_URL_FROM_DOMAIN_AND_VERSION
    title "CCS Sector Classification Standards"
    description "Standard of codes used to decide what standard to use to classify an item"
    ED= code {
      id :education_funded
      macro &URI_FROM_DOC_AND_ID
      title "ccs eduction funded"
      description "CCS sector coding for education appropriate for education frameworks."+
          "value should be education_funded:true or education_funded:false"
    }
  }
end

ReferenceData.new :SectorStandard do
  SECTOR_STANDARDS = Enum (standard {
    macro &ID_AND_URL_FROM_DOMAIN_AND_VERSION
    title "Sector Classification Standards"
    description "Standard of codes used to decide what standard to use to classify an item"
    ref {
      link_standard_from_codelist(self, CCSSECTORS)
    }
    ref {
      id :other
      macro &URI_FROM_DOC_AND_ID
      prefix :other
      title "Other sector coding"
      description "Other / unknown sector coding standard"
      source "none"
    }
  })
end

ReferenceData.new :CCSOrg do
  CCS_ORG_CODES = Enum(codelist {
    macro &ID_AND_URL_FROM_DOMAIN_AND_VERSION
    title "CCS Org structure"
    description "CCS Structure codes"
    BUILDINGS= code {
      id :pillar_buildings
      macro &URI_FROM_DOC_AND_ID
    }
    EDUCATION= code {
      id :category_education
      macro &URI_FROM_DOC_AND_ID
    }
  }, code_type: :code, code_key: :id)
end

ReferenceData.new :OrgStructureStandard do
  ORG_STRUCT_STANDARDS = Enum(standard {
    macro &ID_AND_URL_FROM_DOMAIN_AND_VERSION
    title "Org structure standards"
    description "How to classify organisation units"
    ref {
      id :ccs_org
      link_standard_from_codelist( self, CCS_ORG_CODES.doc)
    }
  })
end



ReferenceData.new :OrgIdStandard do
  ORG_ID_STANDARDS = Enum (standard {
    macro &ID_AND_URL_FROM_DOMAIN_AND_VERSION
    title "Organisation id Classification Standards"
    description "Standard of codes used to decide what standard to use to classify an item"
    ref {
      id :sf_org_id
      macro &URI_FROM_DOC_AND_ID
      title "CCS Salesforce id"
      description title
      source "CCS Salesforce"
      prefix id
    }
    ref {
      id :companies_house
      macro &URI_FROM_DOC_AND_ID
      title "Companies House"
      description title
      source "Use CH register"
      prefix id
    }
    ref {
      id :dun
      macro &URI_FROM_DOC_AND_ID
      title "Dun & Bradstreet"
      description title
      source "Use D&B register"
      prefix id
    }
    ref {
      id :dfe
      macro &URI_FROM_DOC_AND_ID
      title "DfE"
      description title
      source "Use DfE&B register"
      prefix id
    }
  })
end

ReferenceData.new :ContactIdStandard do
  CONTACT_ID_STANDARDS = Enum (standard {
    macro &ID_AND_URL_FROM_DOMAIN_AND_VERSION
    title "Contact id  Standards"
    description "How to identify a link to a contact"
    SF_CONTACT= ref {
      id :sf_contact
      macro &URI_FROM_DOC_AND_ID
      title "CCS Salesforce id"
      description title
      source "CCS Salesforce"
    }
    EMAIL= ref {
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
  }, code_type: :code)
end
