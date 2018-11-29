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

API.new :MAIN do
  endpoint {
    host "ccs.gov.uk"
    version "0.1.0"
    resource {type Agreements::Agreement}
    resource {type Items::ItemType}
    resource {type Items::Item}
  }
end

# generate reference codes
# get each document out of each reference data domain and create a file based on it's id

REFERENCE_DATA = ReferenceData.instances

REFERENCE_DATA.each do |dom|
  data = DataFile.new(output_path, snake_case(dom.name), fmt: :json, subdir: "reference_data")
  data.output *dom
end

# generate the API
api = OpenApi3.new(output_path, "ccs_api", fmt: :yaml)
api.output API::MAIN

