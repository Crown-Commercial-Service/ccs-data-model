require_relative 'reference_data'


ReferenceData.new :CourseRelatedCodes do
  COURSE_DATA = codelist {
    macro &ID_AND_URL_FROM_DOMAIN_AND_VERSION
    title "Filter Classification Codes specific to Apprenticeships questions"
    description "Codes of codes used to filter offerings and other catalogue entries"
    START_DATE= code {
      id :course_start_date
      macro &URI_FROM_DOC_AND_ID
      title "When does a course start - provide a Date in line with #{DATE.uri}"
      description "When describing course offerings, this can describe the start date of the course"
    }
  }
end

ReferenceData.new :EducationRatingsScheme do
  EDU_RATINGS = scheme {
    macro &ID_AND_URL_FROM_DOMAIN_AND_VERSION
    title "Qualification Classification Schemes"
    description "Scheme of codes used to decide what scheme to use to classify an item"
    OFFSTED_RATING= code {
      id :offsted_rating
      prefix id
      macro &URI_FROM_DOC_AND_ID
      title "Offsted Rating"
      description title
      source "Offsted codes TBD"
    }
  }
end

ReferenceData.new :ApprenticeshipQualificationQuestionnaireScheme do
  APPRENTICESHIP_QUALIFICATION =  scheme {
    macro &ID_AND_URL_FROM_DOMAIN_AND_VERSION
    title "Apprenticeships qualifications questions for suppliers"
    description "Scheme of codes used to decide what scheme to use to classify an item"
    PROVIDER_OFFSTED= code {
      link_scheme_from_code(self, OFFSTED_RATING)
    }
  }
end

ReferenceData.new :ApprenticeshipOfferScheme do
  APPRENTICESHIP_OFFER =  scheme {
    macro &ID_AND_URL_FROM_DOMAIN_AND_VERSION
    title "Apprenticeships qualifications questions for suppliers"
    description "Scheme of codes used to decide what scheme to use to classify an item"
    OFFER_COURSE_START_DATE= code {
      link_scheme_from_code(self, START_DATE)
    }
  }
end

