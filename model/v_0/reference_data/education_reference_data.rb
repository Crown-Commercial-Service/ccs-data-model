require_relative '../reference_data'
require_relative 'supplementary_reference_data'


ReferenceData.new :CourseRelatedCodes do
  COURSE_DATA = codelist {
    macro &ID_AND_URL_FROM_DOMAIN_AND_VERSION
    title "Filter Classification Codes specific to Apprenticeships questions"
    description "Codes of codes used to filter offerings and other catalogue entries"
    START_DATE = code {
      id :course_start_date
      macro &URI_FROM_DOC_AND_ID
      title "When does a course start - provide a Date in line with #{DATE.uri}"
      description "When describing course offerings, this can describe the start date of the course"
      pattern "#{container.id}:#{id}:(DATE)"
    }
    COURSE_LOC = code {
      id :course_location
      macro &URI_FROM_DOC_AND_ID
      title "Where is the course - provide a branch location for the supplier"
      description "Where is the course? Can be multiple options"
      pattern "#{container.id}:#{id}:(branch_id)"
    }
    BESPOKE = code {
      id :is_bespoke_course
      macro &URI_FROM_DOC_AND_ID
      title "bespoke?"
      pattern "#{container.id}:#{id}:(true|false)"
      description "Can the course be bespoked"
    }
    SHARED = code {
      id :is_classroom_shared
      macro &URI_FROM_DOC_AND_ID
      title "shared?"
      pattern "#{container.id}:#{id}:(true|false)"
      description "Classroom is shared"
    }
  }
end

ReferenceData.new :ApprenticeSpecificOfferingCodes do
  codelist {
    macro &ID_AND_URL_FROM_DOMAIN_AND_VERSION
    title "Filter Classification Codes specific to Apprenticeships offering filters"
    description ""
    IN_ESFA_FUNDING = code {
      id :funding_band
      macro &URI_FROM_DOC_AND_ID
      title "within funding band?"
      pattern "#{container.id}:#{id}:(true|false)"
      description "course is within the maximum ESFA cover"
    }
  }
  end

ReferenceData.new :EducationRatingsStandard do
  EDU_RATINGS = standard {
    macro &ID_AND_URL_FROM_DOMAIN_AND_VERSION
    title "Qualification Classification Standards"
    description "Standard of codes used to decide what standard to use to classify an item"
    OFFSTED_RATING = ref {
      id :offsted
      prefix :offsted_rating
      macro &URI_FROM_DOC_AND_ID
      title "Offsted Rating"
      description "Using offsted standard for valid ratings codes"
      pattern "(offsted:)(Outstanding|Good|Requires Improvement|Inadequate)"
      source "https://www.gov.uk/government/organisations/ofsted"
    }
  }
end

ReferenceData.new :ApprenticeshipQualificationQuestionnaireStandard do
  APPRENTICESHIP_QUALIFICATION = standard {
    macro &ID_AND_URL_FROM_DOMAIN_AND_VERSION
    title "Apprenticeships qualifications questions for suppliers"
    description "Standard of codes used to decide what standard to use to classify an item"
    PROVIDER_OFFSTED = ref {
      link_standard_from_code(self, OFFSTED_RATING)
    }
    ref {
      id :supplier_has_experience
      prefix container.id
      macro &URI_FROM_DOC_AND_ID
      title "supplier has experience?"
      pattern "#{container.id}:#{id}:(true|false)"
      description "supplier has experirence in apprenticeships"
    }
  }
end

ReferenceData.new :ApprenticeshipOfferStandard do
  APPRENTICESHIP_OFFER = standard {
    macro &ID_AND_URL_FROM_DOMAIN_AND_VERSION
    title "Apprenticeships qualifications questions for suppliers"
    description "Standard of codes used to decide what standard to use to classify an item." +
                    "This is a mix of custom codes and course codes."

    OFFER_COURSE_START_DATE = ref {
      link_standard_from_code(self, START_DATE)
    }
    ref {
      link_standard_from_code(self, COURSE_LOC)
    }
    ref {
      link_standard_from_code(self, SHARED)
    }
    ref {
      link_standard_from_code( self, IN_ESFA_FUNDING)
    }
  }
end

