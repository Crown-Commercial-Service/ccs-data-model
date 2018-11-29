
# CCS Data Model

this is an alpha for a public CCS Data Model.

In line with the following ADRs:

- [9. Use common API for Agreements, Parties and Documents](https://github.com/Crown-Commercial-Service/CCS-Architecture-Decision-Records/blob/master/doc/adr/0009-use-common-api-for-agreements-parties-and-documents.md)
- [ADR 0010 - use shared drfinition of cmp agreement](https://github.com/Crown-Commercial-Service/CCS-Architecture-Decision-Records/blob/master/doc/adr/0010-use-shared-definition-of-cmp-agreement-when-building-all-cmp-services.md) 

we want to define the metamodel
for Commertial Agreements and supporting data in a common way, so all
services, interfaces and data types are consistent. 

This prototype

- defines a common metamodel 
- models a number of agreement categories (as alpha prototypes, not as definitive representations)
- produces API definitions in OpenAPI2 (aka Swagger) and OpenAPI3 format
- from the API, produces domain objects 
- produces data domain descriptions


# Things to see

the [model](model/) directory defines our [agreements metamodel](model/v_0/agreement.rb). This defines
 what the required data elements are for agreements.
 
 From this model we will define instances of agreement data to define our agreement structure.
 
the build script generates [outputs](gen) including

- [api definitions](gen/openapi3/ccs_api.yaml)  giving api definition files
- [data files](gen/data) showing the agreements and catalogue entries
- a [picture](gen/images/metamodel.jpg) of the metamodel
- documentation for the agreements and metamodel

# Requirements

- graphviz (for diagrams)

# To do

- [ ] simplify agreement model
    - remove agreement specific elements and move to canonical model
    - build as a defined extention of [OCDS entitites](http://standard.open-contracting.org/latest/en/schema/)
    
- [ ] generate API definition
    - generate OpenAPI2 definition (since that is the version supported by [AWS gateway](https://aws.amazon.com/api-gateway/) )
    
- [ ] move agreement specific definitions to data files in separate project
    - move agreements to data definitions of catalogy and questionnaire format
    - move data to another place


