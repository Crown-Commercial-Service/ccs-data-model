require_relative 'reference_data'

uri=  lambda do
  uri "#{self.container.url}/#{id.to_s.downcase}"
end

ReferenceData.new :UnitScheme do
  ALL_UNITS_SCHEMES = Enum(scheme {
    name :unit_classification_schemes
    url ref_url(name)
    version "0.1.0"
    title "Unit Schemes"
    description "Scheme of codes used to decide what scheme to use to classify units"
    prefix "unitscheme"
    code {
      id :UNCEFACT
      title "UN/CEFACT Recommendation 20"
      description ""
      source "http://tfig.unece.org/contents/recommendation-20.htm"
      include &uri
    }
    code {
      id :QUDT
      title "Quantities, Units, Dimensions and Data Types Ontologies"
      description "Use the [QUDT Code](http://www.qudt.org/qudt/owl/1.0.0/unit/Instances.html) value."
      source "http://www.qudt.org/qudt/owl/1.0.0/unit/Instances.html"
      include &uri
    }
  }, code_key: :uri)
end

