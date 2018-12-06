require_relative "src/diagram"
require_relative "src/doc"
require_relative "src/data"
require_relative 'src/api'
require_relative 'model/v_0/agreement'
require_relative 'model/v_0/party'
require_relative 'model/v_0/reference_data/geographic_reference_data'
require_relative 'model/v_0/api'
require_relative 'model/v_0/examples/sample_payloads'

output_path = File.join(File.dirname(__FILE__), "gen")

# meta data
metamodels = [Agreements, Parties]

diagram = Diagram.new(output_path, "metamodel")
diagram.describe *metamodels

doc = Document.new(output_path, "metamodel")
doc.document_metamodel *metamodels

[:json, :yaml].each do |fmt|
  data = DataFile.new(output_path, "metamodel", fmt: fmt)
  data.output_metamodel *metamodels
end

# generate reference codes
# get each document out of each reference data domain and create a file based on it's id

REFERENCE_DATA = ReferenceData.instances

REFERENCE_DATA.each do |dom|
  data = DataFile.new(output_path, snake_case(dom.name), fmt: :json, subdir: "reference_data/v#{VERSION.major}")
  data.output *dom
end

# generate the API
api_file = OpenApi3.new(output_path, "ccs_api", fmt: :yaml)
api_file.output API::API_V0_1

# Sample data
SAMPLES = [SAMPLE_PARTIES, SAMPLE_CONTACT]

SAMPLES.each do |dom|
  data = DataFile.new(output_path, snake_case(dom.name), fmt: :json, subdir: "samples/v#{VERSION.major}")
  data.output *dom
end
