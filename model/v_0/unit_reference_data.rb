require_relative 'reference_data'



ReferenceData.new :UnitScheme do
  UNITS_SCHEMES = Enum(scheme {
    macro &ID_AND_URL_FROM_DOMAIN_AND_VERSION
    title "Unit Schemes"
    description "Scheme of codes used to decide what scheme to use to classify units"
    prefix "unitscheme"
    code {
      id :uncefact
      macro &URI_FROM_DOC_AND_ID
      title "UN/CEFACT Recommendation 20"
      description ""
      source "http://tfig.unece.org/contents/recommendation-20.htm"
      macro &URI_FROM_DOC_AND_ID
    }
    QUDT= code {
      id :qudt
      macro &URI_FROM_DOC_AND_ID
      title "Quantities, Units, Dimensions and Data Types Ontologies"
      description "Use the [QUDT Code](http://www.qudt.org/qudt/owl/1.0.0/unit/Instances.html) value."
      source "http://www.qudt.org/qudt/owl/1.0.0/unit/Instances.html"
      macro &URI_FROM_DOC_AND_ID
    }
  }, code_key: :uri)
end

