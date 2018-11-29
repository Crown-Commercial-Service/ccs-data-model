require_relative 'reference_data'

ReferenceData.new :LocationScheme do
  LOCATION_SCHEMES = Enum (scheme {
    macro &ID_AND_URL_FROM_DOMAIN_AND_VERSION
    title "Schemes codes to locate geographic areas"
    description "Scheme of codes used to decide what scheme to use to classify an item"
    prefix id
    NUTS= code {
      id :nuts_2016
      macro &URI_FROM_DOC_AND_ID
      title "NUTS coding"
      description "NUTS geo coding"
      source "https://en.wikipedia.org/wiki/NUTS_statistical_regions_of_the_United_Kingdom"
    }
    code {
      id :postcode_raius
      macro &URI_FROM_DOC_AND_ID
      title "Postcode radius coding"
      description "Take a radius in miles from the centre of a postcode." +
                      "code should be of the form <POSTCODE>:<RADIUS IN MILES>"
      source "https://cloud.google.com/maps-platform/"
    }
  })
end

