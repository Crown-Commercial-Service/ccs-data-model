# Data model: Agreements
## Agreement
  General definition of Commercial Agreements

|attribute|type|multiplicity|description|
|---------|----|------------|-----------|
|kind|agreement_type_codes(framework,lot,contract)|1|Kind of agreement, such as Framework, Lot,   Contract. Lots are considered separateagreements, but link to their owning framework agreement. Similarly Contracts should link to anylot that they are based on|
|id|String|1|id of agreeement; This is the RM number for a framework, and {RM#lotnumber} for a lot|
|keyword|String|*|other names for the agreement|
|name|String|1||
|long_name|String|1||
|version|String|1|semantic version id of the agreement model, in the form X.Y.Z|
|status|agreement_status_codes(live,inactive,future,planned,underway,withdrawn,ended)|1||
|pillar|String|1||
|duration|Integer|1|Months|
|category|String|1||
|start_date|Date|1||
|end_date|Date|1||
|original_end_date|Date|1||
|description|String|1|Describe the agreement|
|offerType|String|1|Name of the subclass of the Offering, supporting the Agreement|
|part_of_id|String -> Agreements::Agreement|1|Agreement this is part of, applicable only to Lots|
|conforms_to_id|String -> Agreements::Agreement|1|Agreement this conforms to, such as a Contract conforming to a Framework|
|item_type|Items::ItemType|*|describe the items that can be offered under the agreement|
|min_value|Integer|0..1|Minimum value of award, in pounds sterling|
|max_value|Integer|0..1|Maximum value of award, in pounds sterling|
# Data model: Parties
## Party
  
  The party is used to identify buyers and suppliers. Since some organisations act as
both buyers and suppliers we use the same record for both, but most organisations will
be one or the other. The onvolvement of the party with an agreement determine  the role in
that contenxt.
Details still to be added

|attribute|type|multiplicity|description|
|---------|----|------------|-----------|
|id|String|1|URN, should match salesforce ID; master key|
|parent_org_id|String -> Parties::Party|1|URN, should match salesforce ID|
|duns|String|0..1|Dunn & Bradstreet number - usually suppleirs only|
|urn|String|0..1|Government URN, of the form 100001234|
|company_reg_number|String|0..1||
|org_name|String|1||
|sector_scheme|sector_scheme(ccs)|*||
|sector|String|*||
|trading_name|String|0..1|Salesforce only stores for supplier|
|supplier_registration_completed|Date|1|The party is a supplier who has completed registration|
|buyer_registration_completed|Date|1|The party is a supplier who has completed registration|
|spend_this_year|String|0..1|Salesforce only stores for buyer|
|documents_url|String|0..1|Salesforce links to google drive for this supplier; we will move to S3 in due course|
|account_manager_id|String|0..1|Who manages the account for CCS|
## Address
  Address should include at least address line 1 and ideally post code.
will contain lat/long if we have derived it.
  

|attribute|type|multiplicity|description|
|---------|----|------------|-----------|
|street|String|0..1||
|address_2|String|0..1||
|town|String|0..1||
|county|String|0..1||
|country|String|0..1||
|postcode|String|0..1||
|latitutde|String|0..1|Location from the address for geo search|
|longtitude|String|0..1|Location from the address for geo search|
## Contact
  
  A way of contacting a party. Store contacts in a safe identity store. Do not store personal details elsewhere.
  

|attribute|type|multiplicity|description|
|---------|----|------------|-----------|
|id|String|1|a newly minted UUID for CMp|
|salesforce_id|String|1|a Salesforce Contact_ID column point; of the form CONT-000122663|
|party_id|String -> Parties::Party|1|contact is a link for this party|
|role|String|*|role for CMp|
|first_name|String|1||
|last_name|String|1||
|title|String|0..1|Salesforce; not sure what the constrainst are|
|job_title|String|0..1|Salesforce; free text|
|department|String|0..1|Salesforce - department within org, rather than gov|
|address|Parties::Address|0..1|address of the contact point|
|phone|String|*|phone of the contact point; salesforce only supports one|
|email|String|*|email of the contact point; salesforce only supports two|
|origin|String|0..1|from Salesforce - where the data was entered|
|notes|String|0..1|from Salesforce|
|status|String|0..1|from Salesforce, 'Active'|
|user_research_participane|String|0..1|Y/N: from Salesforce|
|not_to_receive_ccs_emails|String|0..1|Y/N: from Salesforce|
|contact_owner|String|0..1|from Salesforce|
# Data model: Geographic
## AreaCode
  

|attribute|type|multiplicity|description|
|---------|----|------------|-----------|
|name|String|1||
|description|String|1||
|subcode|Geographic::AreaCode|*||
