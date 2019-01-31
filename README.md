
# CCS Data Model

this is an alpha for a public CCS Data Model.

In line with the following ADRs:

- [ADR 009 - use common API for Agreements, Parties and Documents](https://github.com/Crown-Commercial-Service/CCS-Architecture-Decision-Records/blob/master/doc/adr/0009-use-common-api-for-agreements-parties-and-documents.md)
- [ADR 0010 - use shared definition of cmp agreement](https://github.com/Crown-Commercial-Service/CCS-Architecture-Decision-Records/blob/master/doc/adr/0010-use-shared-definition-of-cmp-agreement-when-building-all-cmp-services.md) 

we want to define the data metamodel
for Commertial Agreements and supporting data in a common way, so all
services, interfaces and data types are consistent. 

This prototype

- defines a common metamodel 
- models a number of agreement categories (as alpha prototypes, not as definitive representations)
- produces API definitions in OpenAPI3 (aka Swagger) format
- produces reference data models for data coding (e.g. identify an organisation using Companies House number) 
- produces diagrams, documents etc.


# Things to see

See our models  defined in a simple data definition language. This defines
 what the required data elements are for agreements, parties and offerings. Key models are
 
 - [agreements metamodel](model/v_0/agreement.rb)
 - [party metamodel](model/v_0/party.rb)
 - [offering metamodel](model/v_0/offering.rb)
 
Also the data definition language defines some reference data to define coding standards, such as:

  - [geographic reference data ](model/v_0/reference_data/geographic_reference_data.rb) allows an agreement to determine how locations should be identified

 
 From this model we will define instances of agreement data to define our agreement structure.
the build script generates [outputs](gen) including

- [api definitions](gen/openapi3/ccs_api.yaml)  giving api definition files, from which 
- [openAPI definition (swaggerhub)](https://app.swaggerhub.com/apis/Kevin.Humphries.CCS/test-ccs) is defined
- [data files](gen/data/metamodel.yaml) showing the metamodel as a yaml file 
- a [picture](gen/images/metamodel.jpg) of the metamodel
- and [text documentation](gen/doc/metamodel.md) for the agreements and metamodel

# Requirements

- graphviz (for diagrams)

# To do

- [X] simplify agreement model
    - remove agreement specific elements and move to canonical model
    - build as a defined extention of [OCDS entitites](http://standard.open-contracting.org/latest/en/schema/)
    
- [X] generate API definition
    - generate OpenAPI2 definition: https://app.swaggerhub.com/apis/Kevin.Humphries.CCS/test-ccs (since that is the version supported by [AWS gateway](https://aws.amazon.com/api-gateway/) )
    
- [X] move agreement specific definitions to data files in separate project
    - move agreements to data definitions of catalogy and questionnaire format
    - move data to another place


