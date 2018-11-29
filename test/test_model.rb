require_relative '../src/data_model'
include DataModel

domain :TestRefModel do
  datatype(:Code,
           description: "a code list") {
    attribute :id, String
  }
  datatype(:List) {
    attribute :id, String
    attribute :code, :Code, ZERO_TO_MANY
  }
end

TestRefModel.new :TESTREF do
  LIST= list {
    id :list_for_test_enum
    ONE= code {id :one}
    TWO= code {id :two}
    code {id :three}
  }
end

domain :TestModel do

  datatype(:ArrayParam,
           description: "Thing") {
    attribute :thingname, String
  }

  datatype :Table, description: "Test type" do
    MULT = 0..10
    DESC = "table of values"
    attribute :vals, Integer,
              multiplicity: MULT,
              :description => DESC
    attribute :morevals, String, 2..5, "array of strings"
  end

  datatype :BasicType do
    attribute :id, String
  end

  datatype :Kindly do
    attribute :kind, Enum(LIST, ONE, TWO,code_key: :id), "pick two ids from list"
    attribute :allkinds, Enum(LIST, code_type: :code ,code_key: :id), "all ids"
  end

  datatype :ReferencingType do
    attribute :id, String
    attribute :mate, TestModel::BasicType
  end

  datatype(:ComplexType,
           description: "Thing with things") {
    attribute :string, String
    attribute :things, TestModel::ArrayParam, ZERO_TO_MANY
    attribute :thing_id, String, ZERO_TO_MANY, links: TestModel::ArrayParam
    attribute :strings, String, ZERO_TO_MANY
    attribute :mustbeafter, Date
  }

  datatype(:AnotherType,
           description: "Thing with things") {
    attribute :string, String
  }

  datatype :DerivedType, extends: TestModel::ReferencingType do
    attribute :more, String
  end

  datatype :Empty do
  end

end

TestModel.new :TESTMODEL do

  complextype do
    string "ID1"
    things do
      thingname "thing1"
    end
    things do
      thingname "thing2"
    end
  end

  anothertype do
    string "Anotherthing"
  end

  table do
    vals 1
    vals 2
  end

  referencingtype do
    id :owner
    mate do
      id :content
    end
  end

  kindly do
    kind :one
  end

end
