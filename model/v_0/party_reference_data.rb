require_relative 'reference_data'

ReferenceData.new :CCSSectorCodes do
  CCSSECTORS= codelist {
    version "0.1.0"
    macro &ID_AND_URL_FROM_DOMAIN_AND_VERSION
    title "CCS Sector Classification Schemes"
    description "Scheme of codes used to decide what scheme to use to classify an item"
    prefix "ccs_sector"
    code {
      id :education_funded
      macro &URI_FROM_DOC_AND_ID
      title "ccs eduction funded"
      description "CCS sector coding for education appropriate for education frameworks"
    }
  }
end

ReferenceData.new :SectorScheme do
  SECTOR_SCHEMES = Enum (scheme {
    version "0.1.0"
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


