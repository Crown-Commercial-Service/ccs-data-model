require_relative "src/diagram"
require_relative "src/doc"
require_relative "src/data"
require_relative 'src/api'
require_relative 'model/agreement'
require_relative 'model/party'
require_relative 'model/geographic'
require_relative 'model/api'

output_path = File.join(File.dirname(__FILE__), "gen")

metamodels = [Agreements, Parties, Geographic]

diagram = Diagram.new(output_path, "metamodel")
diagram.describe *metamodels

doc = Document.new(output_path, "metamodel")
doc.document_metamodel *metamodels

data = DataFile.new(output_path, "metamodel", fmt: :json)
data.output_metamodel *metamodels

data = DataFile.new(output_path, "metamodel", fmt: :yaml)
data.output_metamodel *metamodels

reference_models = [
    Geographic::NUTS,
    Parties::SECTORS
]

data = DataFile.new(output_path, "reference_models", fmt: :json)
data.output *reference_models
data = DataFile.new(output_path, "reference_models", fmt: :jsonlines)
data.output *reference_models
data = DataFile.new(output_path, "reference_models", fmt: :yaml)
data.output *reference_models

API.new :MAIN do
  endpoint {
    host "ccs.gov.uk"
    version "0.1.0"
    resource {
      type Agreements::Agreement
    }
  }
end

api = OpenApi3.new(output_path, "ccs_api", fmt: :yaml )
api.output API::MAIN

