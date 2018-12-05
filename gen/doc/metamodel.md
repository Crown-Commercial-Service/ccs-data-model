# Data model: Agreements
## Restriction
  a type with a number of classification attributes, such as sector, location

|attribute|description|type|multiplicity|
|---------|-----------|----|------------|
|sector_scheme|The sector scheme id|sector_scheme( https://github.com/Crown-Commercial-Service/ccs-data-model/tree/master/gen/reference_data/v0/ccs_sector_codes, https://github.com/Crown-Commercial-Service/ccs-data-model/tree/master/gen/reference_data/v0/sector_scheme.json#other)|*|
|sector_id|The sector scheme ids that define to whom the item may be sold. Prefix must match one of the schemes.|String|*|
|location_scheme|The schemes for identifying locations|location_scheme( https://github.com/Crown-Commercial-Service/ccs-data-model/tree/master/gen/reference_data/v0/location_scheme.json#nuts_2016, https://github.com/Crown-Commercial-Service/ccs-data-model/tree/master/gen/reference_data/v0/location_scheme.json#postcode_raius)|*|
|location_id|The location scheme ids that defines  where the items can be offered.|String|*|
## Agreement extends Register::Record
  General definition of Commercial Agreements

|attribute|description|type|multiplicity|
|---------|-----------|----|------------|
|version_id|UUID of this version of the entry|String|1|
|supercedes_id|UUID of this version superceded. May be empty only if this is the  first version|String|0..1|
|datetime|Date of creation or update of this record, date of creation of this version. |DateTime|1|
|checksum|MD5 checksum of the record|String|1|
|url|URL which will retreive this version of the record|String|1|
|kind|Kind of agreement, such as Framework, Lot,Contract. Lots are considered separateagreements, but link to their owning framework agreement. Similarly Contracts should link to anylot that they are based on. See https://github.com/Crown-Commercial-Service/ccs-data-model/tree/master/gen/reference_data/v0/agreement_type_codes for details.|agreement_type_codes( https://github.com/Crown-Commercial-Service/ccs-data-model/tree/master/gen/reference_data/v0/agreement_type_codes.json#framework, https://github.com/Crown-Commercial-Service/ccs-data-model/tree/master/gen/reference_data/v0/agreement_type_codes.json#lot, https://github.com/Crown-Commercial-Service/ccs-data-model/tree/master/gen/reference_data/v0/agreement_type_codes.json#callof, https://github.com/Crown-Commercial-Service/ccs-data-model/tree/master/gen/reference_data/v0/agreement_type_codes.json#contract)|1|
|id|id of agreeement; This is the RM number for a framework, and {RM#lotnumber} for a lot|String|1|
|id_scheme|who to identify the agreement|agreement_id_scheme( https://github.com/Crown-Commercial-Service/ccs-data-model/tree/master/gen/reference_data/v0/agreement_id_scheme.json#ccs_fw_id, https://github.com/Crown-Commercial-Service/ccs-data-model/tree/master/gen/reference_data/v0/agreement_id_scheme.json#lot_number, https://github.com/Crown-Commercial-Service/ccs-data-model/tree/master/gen/reference_data/v0/agreement_id_scheme.json#cf_contract_id)|1|
|keyword|other names for the agreement|String|*|
|name||String|1|
|long_name||String|1|
|status|current status of agreementSee https://github.com/Crown-Commercial-Service/ccs-data-model/tree/master/gen/reference_data/v0/agreement_status_codes for details.|agreement_status_codes( live, inactive, future, planned, underway, withdrawn, ended)|1|
|description|Describe the agreement|String|1|
|start_date||Date|1|
|end_date||Date|1|
|duration|Months|Integer|1|
|original_end_date||Date|1|
|pillar||String|1|
|category||String|1|
|restriction|Restrictions that may apply|Agreements::Restriction|0..1|
|part_of_id|Agreement this is part of, applicable only to Lots|String -> Agreements::Agreement|1|
|conforms_to_id|Agreement this conforms to, such as a Contract conforming to a Framework|String -> Agreements::Agreement|1|
|item_type|describe the items that can be offered under the agreement|Items::ItemType|*|
|supplier_qualification_scheme|schemes describing coding for suppliers qualification questionnaires|String|*|
|min_value|Minimum value of award, in pounds sterling|Integer|0..1|
|max_value|Maximum value of award, in pounds sterling|Integer|0..1|
# Data model: Parties
## Question extends Register::Record
  A managed set of qualification questions andwered at a point in time for a period of time

|attribute|description|type|multiplicity|
|---------|-----------|----|------------|
|version_id|UUID of this version of the entry|String|1|
|supercedes_id|UUID of this version superceded. May be empty only if this is the  first version|String|0..1|
|datetime|Date of creation or update of this record, date of creation of this version. |DateTime|1|
|checksum|MD5 checksum of the record|String|1|
|url|URL which will retreive this version of the record|String|1|
|id|UUID for the questionnaire entry|String|1|
|classification|coded answers to questions matching the schemes|String|1|
|answer_code|coded answers to questions matching the schemes|String|0..1|
|supplementary_classification|coded answers to questions matching the schemes|String|*|
|supplementary_fields|additional filters used to qulify the item. Filter schemes should obviously be relevant to the item|Supplementary::Field|*|
## Questionnaire
  A managed set of qualification questions andwered at a point in time for a period of time

|attribute|description|type|multiplicity|
|---------|-----------|----|------------|
|id|UUID for the questionnaire entry|String|1|
|completed||Date|1|
|expires||Date|1|
|question_schemes|The coding schemes for the questions and answers|String|*|
|question|coded answers to questions matching the schemes|Parties::Question|0..1|
## Party
  The party is used to identify buyers and suppliers. Since some organisations act asboth buyers and suppliers we use the same record for both, but most organisations willbe one or the other. The onvolvement of the party with an agreement determine the role inthat contenxt.

|attribute|description|type|multiplicity|
|---------|-----------|----|------------|
|id| URN, should match salesforce ID; master key |String|1|
|org_id_scheme||org_id_scheme( https://github.com/Crown-Commercial-Service/ccs-data-model/tree/master/gen/reference_data/v0/org_id_scheme.json#sf_org_id, https://github.com/Crown-Commercial-Service/ccs-data-model/tree/master/gen/reference_data/v0/org_id_scheme.json#companies_house, https://github.com/Crown-Commercial-Service/ccs-data-model/tree/master/gen/reference_data/v0/org_id_scheme.json#dun, https://github.com/Crown-Commercial-Service/ccs-data-model/tree/master/gen/reference_data/v0/org_id_scheme.json#dfe)|1|
|supplementary_org_id_schemens||org_id_scheme( https://github.com/Crown-Commercial-Service/ccs-data-model/tree/master/gen/reference_data/v0/org_id_scheme.json#sf_org_id, https://github.com/Crown-Commercial-Service/ccs-data-model/tree/master/gen/reference_data/v0/org_id_scheme.json#companies_house, https://github.com/Crown-Commercial-Service/ccs-data-model/tree/master/gen/reference_data/v0/org_id_scheme.json#dun, https://github.com/Crown-Commercial-Service/ccs-data-model/tree/master/gen/reference_data/v0/org_id_scheme.json#dfe)|*|
|supplementary_org_id||String|*|
|parent_org_id| URN, should match one of the schemes listed |String -> Parties::Party|1|
|org_name||String|1|
|sector_scheme||sector_scheme( https://github.com/Crown-Commercial-Service/ccs-data-model/tree/master/gen/reference_data/v0/ccs_sector_codes, https://github.com/Crown-Commercial-Service/ccs-data-model/tree/master/gen/reference_data/v0/sector_scheme.json#other)|*|
|sector||String|*|
|trading_name| Salesforce only stores for supplier. |String|0..1|
|spend_this_year| Salesforce only stores this for buyers. |Float|0..1|
|documents_url| Salesforce links to google drive folder for this supplier; we will move to S3 in due course. |String|0..1|
|contact_scheme||contact_id_scheme( https://github.com/Crown-Commercial-Service/ccs-data-model/tree/master/gen/reference_data/v0/contact_id_scheme.json#sf_contact, https://github.com/Crown-Commercial-Service/ccs-data-model/tree/master/gen/reference_data/v0/contact_id_scheme.json#email)|0..1|
|account_manager_id| Who manages the account for CCS |String|0..1|
## Address
  
 Address should include at least address line 1 and ideally post code.
 will contain lat / long if we have derived it.
 

|attribute|description|type|multiplicity|
|---------|-----------|----|------------|
|street||String|0..1|
|address_2||String|0..1|
|town||String|0..1|
|county||String|0..1|
|country||String|0..1|
|postcode||String|0..1|
|latitutde| Location from the address for geo search |String|0..1|
|longtitude| Location from the address for geo search |String|0..1|
## Contact
  A way of contacting a party.Store contacts in a safe identity store.Do not store personal details elsewhere. 

|attribute|description|type|multiplicity|
|---------|-----------|----|------------|
|contact_scheme||contact_id_scheme( https://github.com/Crown-Commercial-Service/ccs-data-model/tree/master/gen/reference_data/v0/contact_id_scheme.json#sf_contact, https://github.com/Crown-Commercial-Service/ccs-data-model/tree/master/gen/reference_data/v0/contact_id_scheme.json#email)|1|
|id| a newly minted UUID for CMp |String|1|
|supplementary_contact_id_schemens||contact_id_scheme( https://github.com/Crown-Commercial-Service/ccs-data-model/tree/master/gen/reference_data/v0/contact_id_scheme.json#sf_contact, https://github.com/Crown-Commercial-Service/ccs-data-model/tree/master/gen/reference_data/v0/contact_id_scheme.json#email)|*|
|supplementary_contact_id||String|*|
|party_id| contact is a link for this party |String -> Parties::Party|1|
|role| role for CMp |String|*|
|first_name||String|1|
|last_name||String|1|
|title| Salesforce; not sure what the constrainst are |String|0..1|
|job_title| Salesforce; free text |String|0..1|
|department| Salesforce - department within org, rather than gov |String|0..1|
|address| address of the contact point |Parties::Address|0..1|
|phone| phone of the contact point; salesforce only supports one |String|*|
|email| email of the contact point; salesforce only supports two |String|*|
|origin| from Salesforce - where the data was entered |String|0..1|
|notes| from Salesforce |String|0..1|
|status| from Salesforce, 'Active' |String|0..1|
|user_research_participane| Y / N : from Salesforce |String|0..1|
|not_to_receive_ccs_emails| Y / N : from Salesforce |String|0..1|
|contact_owner| from Salesforce |String|0..1|
