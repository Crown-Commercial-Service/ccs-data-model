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
  attr_accessor :fmt, :std_qry_params, :std_path_params


  def initialize dir, name, fmt: :json

    super File.join(dir, "openapi3"),
          name, fmt.to_s
    self.fmt = fmt
    self.std_qry_params = [:name, :id, :keyword, :title]
    self.std_path_params = [:id]
  end

  BROWSERS = "browser"
  RECORDERS = "recorder"
  SUMMARY = "summary"
  RESPONSES = "responses"
  NAME = "name"
  DESCRIPTION = "description"
  OPERATION_ID = "operationId"
  TAGS = "tags"
  PARAMETERS = "parameters"
  REF = "$ref"
  R200 = "200"
  R4XX = "4XX"
  GET = "get"
  POST = "post"
  PUT = "put"
  PATHS = "paths"
  INFO = "info"
  REQUEST_BODY = "requestBody"
  CONTENT = "content"
  SCHEMA = "schema"
  APPLICATION_JSON = "application/json"
  PAGING_CONTROL = [:limit, :skip]
  PAGE_LIMIT = 200
  EXAMPLE = "example"

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
        "version" => endpoint.version.to_s,
        "contact" => {"email" => "admin@ccs.gov.uk"},
        "license" => {NAME => "MIT", "url" => "https://github.com/Crown-Commercial-Service/ccs-data-model/blob/master/LICENSE"}
    }
    map[TAGS] = [
        {NAME => BROWSERS,
         DESCRIPTION => "for all users, typically buyers"
        }, {NAME => RECORDERS,
            DESCRIPTION => "for record updaters, often suppliers"
        }]

    paths = map[PATHS] = {}

    all_types = []

    endpoint.resource.each do |resource|
      resource_name = resource.type.typename
      api_root = "/api"
      vroot = "#{api_root}/v#{endpoint.version.major}"
      # paths["#{api_root}/#{resource_name}"] = {
      #     GET => {
      #         SUMMARY => "get latest version for api",
      #         TAGS => [BROWSERS],
      #         SUMMARY => "redirect for search",
      #         OPERATION_ID => "search-#{resource_name}",
      #         DESCRIPTION => "searches #{resource_name} by name, id or keyword",
      #         RESPONSES => {
      #             "302" =>   {DESCRIPTION => "Redirect to the latest semantic version API"}
      #         }
      #     }
      # }
      paths["#{vroot}/#{resource_name}"] = {
          GET => {
              SUMMARY => "get list",
              TAGS => [BROWSERS],
              SUMMARY => "search",
              OPERATION_ID => "search-#{resource_name}",
              DESCRIPTION => "searches #{resource_name} by name, id or keyword",
              PARAMETERS => std_qry_params
                                .select {|k| resource.type.attributes.has_key? k}
                                .map {|k| {REF => ref_component(:query, k)}}
                                .concat(PAGING_CONTROL.map {|k| {REF => ref_component(:query, k)}}),
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
              SUMMARY => "post a new element",
              TAGS => [RECORDERS],
              SUMMARY => "post",
              OPERATION_ID => "create-#{resource_name}",
              DESCRIPTION => "add a new #{resource_name} and retreive copy of it",
              REQUEST_BODY => {
                  CONTENT => {
                      APPLICATION_JSON => {
                          SCHEMA => {
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
      paths["#{vroot}/#{resource_name}/{id}"] = {
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
          },
          PUT => {
              SUMMARY => "put an updated element",
              TAGS => [RECORDERS],
              SUMMARY => "put",
              OPERATION_ID => "revise-#{resource_name}",
              DESCRIPTION => "update an existing #{resource_name} given its id",
              PARAMETERS => [{REF => ref_component(:path, "id")}],
              REQUEST_BODY => {
                  CONTENT => {
                      APPLICATION_JSON => {
                          SCHEMA => {
                              REF => ref_component(:schema, resource_name)
                          }
                      }
                  },
                  DESCRIPTION => "body should be the updated #{resource_name}"
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
    end # each resource

    components = map["components"] = {}

    schemas = components["schemas"] = {}

    all_types_for_endpoint(endpoint).each do |t|
      schema = detail_component_type(:schema, t)
      schemas[schema[0]] = schema[1]
    end

    # TODO - document params
    # TODO multiple params, e.g. keyword
    # TODO form params
    parameters = components[PARAMETERS] = {}
    std_qry_params.each do |p|
      param = detail_component_param(:query, p, description: "optional search parameter")
      parameters[param[0]] = param[1]
    end

    std_path_params.each do |p|
      param = detail_component_param(:path, p, description: "optional id parameter")
      parameters[param[0]] = param[1]
    end

    PAGING_CONTROL.each do |p|
      schema = {
          "type" => "integer",
          "format" => "int32",
          "minimum" => 0,
      }
      if (p == :limit)
        schema["maximum"] = PAGE_LIMIT
      end

      param = detail_component_param(:query, p, description: "optional control parameter", schema: schema)
      parameters[param[0]] = param[1]
    end

    responses = components[RESPONSES] = {}
    endpoint.resource.each do |r|
      param = detail_component_type(:response, r.type)
      responses[param[0]] = param[1]
      param = detail_component_type(:responses, r.type)
      responses[param[0]] = param[1]
    end

    save(map)

  end

  private

  def all_types_for_endpoint(endpoint)
    all_schemas = endpoint.resource.map {|r| r.type}

    all_schemas.each do |t|
      t.attributes.each_value do |v|
        t = v[:type]
        if t <= DataType && !all_schemas.include?(t)
          all_schemas << t
        end
      end
    end
    all_schemas
  end

  # get named parameter definition - name is prefixed by _ if a query param
  # return [param name, param detail]
  def detail_component_param(qryOrPath, name, schema: {"type" => "string"}, description: "")
    case qryOrPath
    when :query then
      name = "q_" + name.to_s
      [name, {
          "name" => name.to_s,
          "in" => 'query',
          "description" => description,
          SCHEMA => schema
      }]
    when :path then
      name = name.to_s
      [name, {
          "name" => name,
          "in" => 'path',
          "required" => true,
          "description" => description,
          SCHEMA => schema
      }]
    end
  end

  def detail_component_type(achemaOrResponseOrResponses, type)
    case achemaOrResponseOrResponses
    when :schema then
      name = type.typename.to_s
      [name,
       {
           "type" => "object",
           "required" => ["id", NAME], #TODO all attributes that are min nonzero
           "properties" => datatype_properties(type),
           "description" => type.description
       }
      ]
    when :response then
      name = type.typename.to_s
      [name,
       {
           DESCRIPTION => "#{type.typename} matching id",
           CONTENT => {
               APPLICATION_JSON => {
                   SCHEMA => {
                       REF => ref_component(:schema, name)
                   }
               }
           }
       }
      ]
    when :responses then
      name = type.typename.to_s
      [name + "s", #TODO proper i18n pluralization
       {
           DESCRIPTION => "array of #{type.typename}s matching id",
           CONTENT => {
               APPLICATION_JSON => {
                   SCHEMA => {
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
    name = name.to_s
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


  def datatype_properties type
    property_set = {}
    type.attributes.each_value do |v|
      p = {}
      attype = v[:type]
      if (attype <= String)
        p.merge!({"type" => "string"})
      elsif (attype <= Date)
        p.merge!({"type" => "string",
                  "format" => "date"})
      elsif (attype <= Integer)
        p.merge!({"type" => "integer"})
      elsif (attype <= Float)
        p.merge!({"type" => "number",
                  "format" => "float"})
      elsif (attype <= Version)
        p.merge!({"type" => "string"})
      elsif (attype <= DataType)
        p.merge!({"$ref" => ref_component(:schema, attype.typename)
                 })
      elsif (attype <= Selection)
        p.merge!({"type" => "string",
                  "enum" => attype.ids.map {|c| c.to_s}})
      else
        print("Warning: don't understand schema for #{attype.to_s}\n")
        p.merge!({"type" => "string"})
      end
      if v[:multiplicity].end > 1 || v[:multiplicity].end < 0
        p = {
            "type" => "array",
            "items" => p
        }
      end
      example = v[:example]
      if (nil != example)
        p[EXAMPLE] = example
      end
      desc = v[:description]
      if (nil != desc && !(attype <= DataType))
        p[DESCRIPTION] = desc
      end
      property_set[v[:name].to_s] = p
    end
    property_set
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

