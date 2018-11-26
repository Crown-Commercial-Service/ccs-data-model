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


# noinspection RubyStringKeysInHashInspection
class OpenApi3 < Output
  attr_accessor :fmt, :std_qry_params


  def initialize dir, name, fmt: :json

    super File.join(dir, "openapi3"),
          name, fmt.to_s
    self.fmt = fmt
    self.std_qry_params = [:name, :id, :keyword]
  end

  BROWSERS = "browser"

  RECORDERS = "recorder"

  SUMMARY = "summary"

  RESPONSES = "responses"

  DESCRIPTION = "description"

  NAME = "name"

  TAGS = "tags"

  PARAMETERS = "parameters"

  REF = "$ref"

  R200 = "200"

  R4XX = "4XX"

  GET = "get"

  PATHS = "paths"

  INFO = "info"

  PUT = "put"

  POST = "post"

  OPERATION_ID = "operationId"

  def output api

    if api.contents[:endpoint].length != 1
      raise "only one endpoint"
    end
    endpoint = api.contents[:endpoint][0]

    map = {}
    map["openapi"] = "3.0.4"
    map["servers"] = [{DESCRIPTION => "generated server for #{endpoint.class.name}",
                       "url" => endpoint.host}]
    map[INFO] = {
        "title" => endpoint.class.name,
        DESCRIPTION => "genearated endpoint for data #{endpoint.class.name}",
        "version" => endpoint.version,
        "contact" => {"email" => "admin@ccs.gov.uk"},
        "license" => {NAME => "MIT", "url" => "https://github.com/Crown-Commercial-Service/ccs-data-model/blob/master/LICENSE"}
    }
    map[TAGS] = [
        {NAME => BROWSERS,
         DESCRIPTION => "for all users, especially buyers"
        }, {NAME => RECORDERS,
            DESCRIPTION => "for record updaters"
        }]

    paths = map[PATHS] = {}

    endpoint.resource.each do |resource|
      resource_name = resource.type.typename.downcase
      paths["/#{resource_name}"] = {
          GET => {
              SUMMARY => "get list",
              TAGS => [BROWSERS],
              SUMMARY => "search",
              OPERATION_ID => "search-#{resource_name}",
              DESCRIPTION => "searches #{resource_name} by name, id or keyword",
              PARAMETERS => std_qry_params.map {|k| {REF => ref_component(:query, k)}},
              RESPONSES => {
                  R200 => {
                      REF => ref_component(:responses, resource_name)
                  },
                  R4XX => {
                      DESCRIPTION => "error TODO"
                  }
              }
          },
          POST => {
              SUMMARY => "put a new element",
              TAGS => [RECORDERS],
              SUMMARY => "put",
              OPERATION_ID => "create-#{resource_name}",
              DESCRIPTION => "add a new #{resource_name} and retreive copy of it",
              "requestBody" => {
                  "content" => {
                      "application/json" => {
                          "schema" => {
                              REF => ref_component(:schema, resource_name)
                          }
                      }
                  },
                  DESCRIPTION => "body should be the new #{resource_name}"
              },
              RESPONSES => {
                  R200 => {
                      REF => ref_component(:response, resource_name)
                  },
                  R4XX => {
                      DESCRIPTION => "error TODO"
                  }
              }
          }
      }
      paths["/#{resource_name}/{id}"] = {
          GET => {
              SUMMARY => "get item",
              TAGS => [RECORDERS],
              SUMMARY => "get a #{resource_name}",
              DESCRIPTION => "retrieve #{resource_name} by id",
              PARAMETERS => [{REF => ref_component(:path, "id")}],
              RESPONSES => {
                  R200 => {
                      REF => ref_component(:response, resource_name)
                  },
                  R4XX => {
                      DESCRIPTION => "error TODO"
                  }
              }
          }
      }
    end

    components = map["components"] = {}

    schemas = components["schemas"] = {}
    endpoint.resource.each do |r|
      schema = detail_component(:schema, r.type)
      schemas[schema[0]] = schema[1]
    end

    parameters = components[PARAMETERS] = {}
    @std_qry_params.each do |p|
      param = detail_component(:query, p)
      parameters[param[0]] = param[1]
    end
    [:id].each do |p|
      param = detail_component(:path, p)
      parameters[param[0]] = param[1]
    end

    responses = components[RESPONSES] = {}
    endpoint.resource.each do |r|
      param = detail_component(:response, r.type)
      responses[param[0]] = param[1]
      param = detail_component(:responses, r.type)
      responses[param[0]] = param[1]
    end

    save(map)

  end

  private

  # get named parameter definition - name is prefixed by _ if a query param
  # return [param name, param detail]
  def detail_component(qryOrPathOrSchemaOrResponse, nameOrType)
    case qryOrPathOrSchemaOrResponse
    when :query then
      name = "q_" + nameOrType.to_s
      [name, {
          "name" => nameOrType.to_s,
          "in" => 'query',
          "schema" => {"type" => "string"}
      }]
    when :path then
      name = nameOrType.to_s
      [name, {
          "name" => name,
          "in" => 'path',
          "required" => true,
          "schema" => {"type" => "string"}
      }]
    when :schema then
      name = nameOrType.typename.to_s.downcase
      [name,
       {
           "type" => "object",
           "required" => ["id", NAME] #TODO all attributes that are nonzero
       }
      ]
    when :response then
      name = nameOrType.typename.to_s.downcase
      [name,
       {
           DESCRIPTION => "#{nameOrType.typename} matching id",
           "content" => {
               "application/json" => {
                   "schema" => {
                       REF => ref_component(:schema, name)
                   }
               }
           }
       }
      ]
    when :responses then
      name = nameOrType.typename.to_s.downcase
      [name + "s", #TODO proper i18n pluralization
       {
           DESCRIPTION => "array of #{nameOrType.typename}s matching id",
           "content" => {
               "application/json" => {
                   "schema" => {
                       "type" => "array",
                       "items" => {
                           REF => ref_component(:schema, name)
                       }
                   }
               }
           }
       }
      ]
    else
      raise "unk"
    end
  end

  def ref_component(qryOrPathOrSchemaOrResponse, name)
    case qryOrPathOrSchemaOrResponse
    when :query
      "#/components/parameters/q_#{name}"
    when :path
      "#/components/parameters/#{name}"
    when :response
      "#/components/responses/#{name}"
    when :responses
      "#/components/responses/#{name}s" #TODO i18n
    when :schema
      "#/components/schemas/#{name}"
    else
      raise "unk"
    end
  end

  def save(map)
    file do |file|
      if fmt == :json
        file.print(JSON.generate(map))
      elsif fmt == :yaml
        file.print(map.to_yaml({header: false}))
      else
        raise " not allowed data file format #{fmt}"
      end
    end
  end
end

