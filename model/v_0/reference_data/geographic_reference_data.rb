require_relative '../reference_data'

ReferenceData.new :LocationStandard do
  LOCATION_STANDARDS = Enum (standard {
    macro &ID_AND_URL_FROM_DOMAIN_AND_VERSION
    title "Standards codes to locate geographic areas"
    description "Standard of codes used to decide what standard to use to classify an item"
    NUTS= ref {
      id :nuts_2016
      macro &URI_FROM_DOC_AND_ID
      title "NUTS coding"
      description "NUTS geo coding"
      source "https://en.wikipedia.org/wiki/NUTS_statistical_regions_of_the_United_Kingdom"
    }
    ref {
      id :postcode_radius
      macro &URI_FROM_DOC_AND_ID
      title "Postcode radius coding"
      description "Take a radius in miles from the centre of a postcode." +
                      "code should be of the form <POSTCODE>:<RADIUS IN MILES>"
      source "https://cloud.google.com/maps-platform/"
    }
  })
end

