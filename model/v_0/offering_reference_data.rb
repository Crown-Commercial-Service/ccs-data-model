require_relative 'reference_data'

ReferenceData.new :CCSApprenticeshipsFilterCodes do
  CCAPPRENTICESHIPSFILTERS = codelist {
    macro &ID_AND_URL_FROM_DOMAIN_AND_VERSION
    title "CCS Filter Classification Schemes"
    description "Scheme of codes used to filter apprenticeships"
    prefix "apprenticeship-filter"
    code {
      id "classroom:is-shared:BOOL"
      macro &URI_FROM_DOC_AND_ID
      description "defines if the classroom is shared"
      title id
      example "#{container.prefix}:#{id.gsub(/BOOL/, 'true')}"
    }
    code {
      id "course-can-be-customised:BOOL"
      macro &URI_FROM_DOC_AND_ID
      title id
      example "#{container.prefix}:#{id.gsub(/BOOL/, 'true')}"
    }
  }
end

ReferenceData.new :FilterScheme do
  FILTER_SCHEMES = Enum (scheme {
    macro &ID_AND_URL_FROM_DOMAIN_AND_VERSION
    title "Filter Classification Schemes"
    description "Scheme of codes used to filter offerings and other catalogue entries"
    prefix id
    code {
      id :apprenticeships
      macro &URI_FROM_DOC_AND_ID
      title "Coding for CCS Apprenticeships service"
      description "Use value codes from #{CCAPPRENTICESHIPSFILTERS.id}, appending the code with the value as described"
      source CCAPPRENTICESHIPSFILTERS.url
    }
  })
end



