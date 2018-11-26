require_relative "src/diagram"
require_relative "src/doc"
require_relative "src/data"
require_relative 'model/agreement'
require_relative 'model/party'
require_relative 'model/geographic'

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
