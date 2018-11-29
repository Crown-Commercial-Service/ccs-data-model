require_relative 'reference_data'

ReferenceData.new :CCSSectorScheme do
  CCSSECTORS= codelist {
    name :ccs_sector_classification
    url ref_url(name)
    version "0.1.0"
    title "CCS Sector Classification Schemes"
    description "Scheme of codes used to decide what scheme to use to classify an item"
    prefix "ccs_sector"
    code {
      id :education_funded
      title "ccs eduction funded"
      description "CCS sector coding for education appropriate for education frameworks"
    }
  }
end

ReferenceData.new :SectorScheme do
  SECTOR_SCHEMES = Enum (scheme {
    name :sector_classification_schemes
    url ref_url(name)
    version "0.1.0"
    title "Sector Classification Schemes"
    description "Scheme of codes used to decide what scheme to use to classify an item"
    prefix "sectorscheme"
    code {
      id :ccs
      title "CCS sector coding"
      description "CCS defined sector coding"
      source CCSSECTORS.url
    }
  })
end


