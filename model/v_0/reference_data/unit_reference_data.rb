require_relative '../reference_data'



ReferenceData.new :UnitStandard do
  UNITS_STANDARDS = Enum(standardlist {
    macro &ID_AND_URL_FROM_DOMAIN_AND_VERSION
    title "Unit Standards"
    description "Standard of codes used to decide what standard to use to classify units"
    standard {
      id :uncefact
      macro &URI_FROM_DOC_AND_ID
      title "UN/CEFACT Recommendation 20"
      description ""
      source "http://tfig.unece.org/contents/recommendation-20.htm"
      macro &URI_FROM_DOC_AND_ID
    }
    QUDT= standard {
      id :qudt
      macro &URI_FROM_DOC_AND_ID
      title "Quantities, Units, Dimensions and Data Types Ontologies"
      description "Use the [QUDT Code](http://www.qudt.org/qudt/owl/1.0.0/unit/Instances.html) value."
      source "http://www.qudt.org/qudt/owl/1.0.0/unit/Instances.html"
      macro &URI_FROM_DOC_AND_ID
    }
  }, code_key: :uri)
end

