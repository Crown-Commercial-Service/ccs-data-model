require_relative 'transform'
include Transform
require 'json'
require 'yaml'
require 'pp'

# - create a file for each data type
# - create a file for each end point, referencing files
#   - link https://swagger.io/docs/specification/using-ref/
# - consider API endpoint config
#   - e.g. AWS - https://app.swaggerhub.com/help/integrations/amazon-api-gateway
# - consider publishing on build
#   - https://app.swaggerhub.com/help/integrations/webhook
#


class OpenApi3 < Output
  attr_accessor :fmt, :path_params

  def initialize dir, name, fmt: :json
    super File.join(dir, "openapi3"), name,
          (fmt == :json ? "json" : (fmt == :yaml ? "yaml" : raise(fmt)))
    self.fmt = fmt
    self.path_params = [:name, :id, :keyword]
  end


  BROWSERS = "browser"

  RECORDERS = "recorder"

  def output api

    if api.contents[:endpoint].length != 1
      raise "only one endpoint"
    end
    endpoint = api.contents[:endpoint][0]

    map = {}
    map["openapi"] = "3.0.4"
    map["servers"] = [{"description": "generated server for #{endpoint.class.name}",
                       "url": endpoint.host}]
    map["info"] = {
        "title": endpoint.class.name,
        "description": "genearated endpoint for data #{endpoint.class.name}",
        "version": endpoint.version,
        "contact": {"email": "ccs.gov.uk"},
        "license": {"name": "MIT", "url": "https://github.com/Crown-Commercial-Service/ccs-data-model/blob/master/LICENSE"}
    }
    map["tags"] = [{"name": BROWSERS,
                    "description": "for all users, especially buyers"
                   }, {"name": RECORDERS,
                       "description": "for record updaters"
                   }]

    paths = map["paths"] = {}

    endpoint.resource.each do |r|
      name = r.type.typename
      paths["/#{name}"] = {
          "get": {
              "summary": "get list",
              "tags": [BROWSERS]
          },
          "summary": "search",
          "description": "searches #{name} by name, id or keyword",
          "parameters": path_params.map {|k| {"$ref": ref(:query, k)}},
          "repsonses": [
              "200": {
                  "$ref": ref(:query, name)
              },
              "4XX": {
                  "description": "error TODO"
              }
          ]
      }
      paths["/#{name}/{id}"] = {
          "get": {
              "summary": "get item",
              "tags": [RECORDERS]
          },
          "summary": "get a #{name}",
          "description": "retrieve #{name} by id",
          "parameters": [{"$ref": ref(:query, "id")}],
          "repsonses": [
              "200": {
                  "$ref": ref(:element, name)
              },
              "4XX": {
                  "description": "error TODO"
              }
          ]
      }
    end

    components = map["components"] = {}

    schemas = components["schemas"] = {}
    endpoint.resource.each do |r|
      schema = detail(:schema, r.type)
      schemas[schema[0]] = schema[1]
    end

    parameters = components["parameters"] = {}
    @path_params.each do |p|
      param = detail(:query, p)
      parameters[param[0]] = param[1]
    end

    save(map)

  end

  private

  # get named parameter definition - name is prefixed by _ if a query param
  # return [param name, param detail]
  def detail(qryOrPathOrSchema, nameOrType)
    case qryOrPathOrSchema
    when :query then
      ["_" + nameOrType.to_s, {
          "in": 'query',
          "required": "false",
          "schema": {"type": "string"}
      }]
    when :path then
      [nameOrType.to_s, {
          "in": 'path',
          "required": "true",
          "schema": {"type": "string"}
      }]
    when :schema then
      [nameOrType.typename,
       {
           "type": "object",
           "required": ["id", "name"] #TODO all attributes that are nonzero

       }
      ]
    else
      raise "unk"
    end
  end

  def ref(qryPathOrElement, p)
    prefix = (qryPathOrElement == :query) ? "_" : ""
    "#/components/parameters/#{prefix}#{p}"
  end

  def save(map)
    file do |file|
      if fmt == :json
        file.print(JSON.generate(map))
      elsif fmt == :yaml
        file.print(map.to_yaml({header: false}))
      else
        raise " unknown data file format "
      end
    end
  end
end

