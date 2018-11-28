# Data model: Agreements
## ItemType
  Defines the items that can be offered in any selected agreements
                Agreements hava a number of items that can have values defining the agreement. The Items should
                constrain the key quantifiable elements of an agreement award. A supplier may provide additional
                variable facts in their Offer to supplement the description of how they support the agreement.

|attribute|type|multiplicity|description|
|---------|----|------------|-----------|
|id|String|1|The composite code string, which must be unique across all schemesMake this up by taking the scheme_id and appending the code id|
|description|String|1|long description|
|keyword|String|*|alternate names for the item type|
|scheme_id|ItemClassificationSchemes(CPV,CPVS,GSIN,UNSPSC,CPC)|1|The classiciation scheme id|
|code|String|1| Code within the scheme defining this type|
|unit_scheme|UnitClassificationSchemes(UNCEFACT,QUDT)|1| define the unit scheme |
|unit|String|1| define the units, if one units matches |
## ExpressionOfNeed
   Defines a buyer 's need which can be matched to agreement items and other details
The need matches closely to our definitions of agreements under ' items types ' and their classification
schemes, but is not a one-to-one match.

|attribute|type|multiplicity|description|
|---------|----|------------|-----------|
|buyer_id|String|1|The buyer expressing the need|
|kind|AgreementTypes(Location,Service,Budget)|1||
|value|String|1||
|unit_scheme|String|1|The units typically used to express the need|
## Agreement
  General definition of Commercial Agreements

|attribute|type|multiplicity|description|
|---------|----|------------|-----------|
|kind|AgreementTypes(Framework,Lot,Contract)|1|Kind of agreement, such as Framework, Lot,   Contract. Lots are considered separateagreements, but link to their owning framework agreement. Similarly Contracts should link to anylot that they are based on|
|id|String|1|id of agreeement; This is the RM number for a framework, and {RM#lotnumber} for a lot|
|keyword|String|*|other names for the agreement|
|name|String|1||
|long_name|String|1||
|version|String|1|semantic version id of the agreement model, in the form X.Y.Z|
|status|AgreementStatuses(Live,Inactive,Future,Planned,Underway,Withdrawn,Ended)|1||
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
|item_type|Agreements::ItemType|*|describe the items that can be offered under the agreement|
|min_value|Integer|0..1|Minimum value of award, in pounds sterling|
|max_value|Integer|0..1|Maximum value of award, in pounds sterling|
## Item
  Specifies the value of an item that is being offered for an agreement

|attribute|type|multiplicity|description|
|---------|----|------------|-----------|
|type_id|String -> Agreements::ItemType|1| type of the item |
|unit|String|1| define the units, which should match one of the allowed unit code valuesin the scheme defind in the type|
|value|Object|1|an object of the type matching type->units|
## Offering
   Supplier offering against an item or items of an agreement.
This may be extended for different agreements. A supplier may provide additional
variable facts in their Offer to supplement the description of how they support the agreement. 

|attribute|type|multiplicity|description|
|---------|----|------------|-----------|
|agreement_id|String -> Agreements::Agreement|1|The agreement this offering relates to|
|supplier_id|String -> Parties::Party|1||
|id|String|1|unique id for the offering across all offerings, suppliers and frameworks|
|name|String|1||
|description|String|1||
|item|Agreements::Item|*|details of the item|
|location_id|String -> Geographic::AreaCode|1..*|Pick list of applicable regions. There must be at least one, even if it is just ' UK '|
|sector_id|String -> Parties::Sector|*|Pick list of applicable sectors.If set offering is only to be shown to users proven to belong to the sectors given|
## Catalogue
   A collection of supplier offerings against an item, for an agreement 

|attribute|type|multiplicity|description|
|---------|----|------------|-----------|
|offers|Agreements::Offering|*|description of the item|
## Involvement
  Involvement relationship between a party and an agreement
Technology strategy documents call this type ' interest ' but perhaps this could
be confused with the accounting interest

|attribute|type|multiplicity|description|
|---------|----|------------|-----------|
|agreement_id|String -> Agreements::Agreement|1|The agreement this interest relates to|
|party_id|String -> Parties::Party|1|The party this interest relates to|
|role|String|1|The role of the party in the involvment|
# Data model: Parties
## Sector
  
  Hierarchy of sector codes delineating the party organisation
  

|attribute|type|multiplicity|description|
|---------|----|------------|-----------|
|name|String|1||
|description|String|1||
|subsector|Parties::Sector|*||
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
|sector|Parties::Sector|*||
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
|street|String|1||
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
