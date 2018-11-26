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
          name,
          case fmt
          when :json then
            "json"
          when :yaml then
            "yaml"
          else
            raise(fmt)
          end
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

  INFO = "info"

  PATHS = "paths"

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

    endpoint.resource.each do |r|
      name = r.type.typename
      paths["/#{name}"] = {
          GET => {
              SUMMARY => "get list",
              TAGS => [BROWSERS],
              SUMMARY => "search",
              DESCRIPTION => "searches #{name} by name, id or keyword",
              PARAMETERS => std_qry_params.map {|k| {REF => ref(:query, k)}},
              RESPONSES => {
                  R200 => {
                      REF => ref(:responses, name)
                  },
                  R4XX => {
                      DESCRIPTION => "error TODO"
                  }
              }
          }
      }
      paths["/#{name}/{id}"] = {
          GET => {
              SUMMARY => "get item",
              TAGS => [RECORDERS],
              SUMMARY => "get a #{name}",
              DESCRIPTION => "retrieve #{name} by id",
              PARAMETERS => [{REF => ref(:path, "id")}],
              RESPONSES => {
                  R200 => {
                      REF => ref(:response, name)
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
      schema = detail(:schema, r.type)
      schemas[schema[0]] = schema[1]
    end

    parameters = components[PARAMETERS] = {}
    @std_qry_params.each do |p|
      param = detail(:query, p)
      parameters[param[0]] = param[1]
    end
    [:id].each do |p|
      param = detail(:path, p)
      parameters[param[0]] = param[1]
    end

    responses = components[RESPONSES] = {}
    endpoint.resource.each do |r|
      param = detail(:response, r.type)
      responses[param[0]] = param[1]
      param = detail(:responses, r.type)
      responses[param[0]] = param[1]
    end

    save(map)

  end

  private

  # get named parameter definition - name is prefixed by _ if a query param
  # return [param name, param detail]
  def detail(qryOrPathOrSchemaOrResponse, nameOrType)
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
      name = nameOrType.typename.to_s
      [name,
       {
           "type" => "object",
           "required" => ["id", NAME] #TODO all attributes that are nonzero
       }
      ]
    when :response then
      name = nameOrType.typename.to_s
      [name,
       {
           DESCRIPTION => "#{nameOrType.typename} matching id",
           "content" => {
               "application/json" => {
                   "schema" => {
                       REF => ref(:schema, nameOrType)
                   }
               }
           }
       }
      ]
    when :responses then
      name = nameOrType.typename.to_s + "s"
      [name, #TODO proper i18n pluralization
       {
           DESCRIPTION => "array of #{nameOrType.typename}s matching id",
           "content" => {
               "application/json" => {
                   "schema" => {
                       "type" => "array",
                       "items" => {
                           REF => ref(:schema, nameOrType)
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

  def ref(qryOrPathOrSchemaOrResponse, nameOrType)
    case qryOrPathOrSchemaOrResponse
    when :query
      "#/components/parameters/q_#{nameOrType}"
    when :path
      "#/components/parameters/#{nameOrType}"
    when :response
      "#/components/responses/#{nameOrType}"
    when :responses
      "#/components/responses/#{nameOrType}s" #TODO i18n
    when :schema
      "#/components/schemas/#{nameOrType.typename}"
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
        raise " unknown data file format "
      end
    end
  end
end

