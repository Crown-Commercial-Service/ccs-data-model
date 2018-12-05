require_relative '../../src/data_model'
require_relative 'party_reference_data'
require_relative 'supplementary_reference_data'
include DataModel

domain(:Parties) {

  datatype(:Question, extends: Register::Record,
           description: "A managed set of qualification questions andwered at a point in time for a period of time") {

    attribute :id, String, "UUID for the questionnaire entry"
    attribute :classification, String, SINGLE, "coded answers to questions matching the schemes",
              example: "#{APPRENTICESHIP_QUALIFICATION.url}"
    attribute :answer_code, String, ZERO_OR_ONE, "coded answers to questions matching the schemes",
              example: "#{OFFSTED_RATING.id}:Requires_Improvement"
    attribute :supplementary_classification, String, ZERO_TO_MANY, "coded answers to questions matching the schemes",
    example: "#{APPRENTICESHIP_QUALIFICATION.url}"
    attribute :supplementary_fields, Supplementary::Field, ZERO_TO_MANY,
              "additional filters used to qulify the item. Filter schemes should obviously be relevant to the item"
  }

  datatype(:Questionnaire,
           description: "A managed set of qualification questions andwered at a point in time for a period of time") {

    attribute :id, String, "UUID for the questionnaire entry"
    attribute :completed, Date
    attribute :expires, Date
    attribute :question_schemes, String, ZERO_TO_MANY, "The coding schemes for the questions and answers",
              example: APPRENTICESHIP_QUALIFICATION.url
    attribute :question, :Question, ZERO_OR_ONE, "coded answers to questions matching the schemes"
  }

  datatype(:Party, description:
      "The party is used to identify buyers and suppliers. Since some organisations act as" +
          "both buyers and suppliers we use the same record for both, but most organisations will" +
          "be one or the other. The onvolvement of the party with an agreement determine the role in" +
          "that contenxt.") {
    attribute :id, String, " URN, should match salesforce ID; master key "
    attribute :org_id_scheme, ORG_ID_SCHEMES
    attribute :supplementary_org_id_schemens, ORG_ID_SCHEMES, ZERO_TO_MANY
    attribute :supplementary_org_id, String, ZERO_TO_MANY
    attribute :parent_org_id, String, " URN, should match one of the schemes listed ", links: :Party
    attribute :org_name, String
    attribute :sector_scheme, SECTOR_SCHEMES, ZERO_TO_MANY
    attribute :sector, String, ZERO_TO_MANY, example: "ccs_sector:education_funded"
    attribute :trading_name, String, ZERO_OR_ONE, " Salesforce only stores for supplier. "
    attribute :spend_this_year, Float, ZERO_OR_ONE, " Salesforce only stores this for buyers. "
    attribute :documents_url, String, ZERO_OR_ONE, " Salesforce links to google drive folder for this supplier; we will move to S3 in due course. "
    attribute :contact_scheme, CONTACT_ID_SCHEMES, ZERO_OR_ONE, example: SF_CONTACT.uri
    attribute :account_manager_id, String, ZERO_OR_ONE, " Who manages the account for CCS "
  }

  datatype(:Address, description: "
 Address should include at least address line 1 and ideally post code.
 will contain lat / long if we have derived it.
 ") {
    attribute :street, String, ZERO_OR_ONE
    attribute :address_2, String, ZERO_OR_ONE
    attribute :town, String, ZERO_OR_ONE
    attribute :county, String, ZERO_OR_ONE
    attribute :country, String, ZERO_OR_ONE
    attribute :postcode, String, ZERO_OR_ONE
    attribute :latitutde, String, ZERO_OR_ONE, " Location from the address for geo search "
    attribute :longtitude, String, ZERO_OR_ONE, " Location from the address for geo search "
  }

  datatype(:Contact, description:
      "A way of contacting a party.Store contacts in a safe identity store.Do not store personal details elsewhere. ") {
    attribute :contact_scheme, CONTACT_ID_SCHEMES, SINGLE, example: SF_CONTACT.uri
    attribute :id, String, " a newly minted UUID for CMp "
    attribute :supplementary_contact_id_schemens, CONTACT_ID_SCHEMES, ZERO_TO_MANY
    attribute :supplementary_contact_id, String, ZERO_TO_MANY
    attribute :party_id, String, " contact is a link for this party ", links: :Party
    #TODO ID Scheme
    attribute :role, String, ZERO_TO_MANY, " role for CMp "
    attribute :first_name, String
    attribute :last_name, String
    attribute :title, String, ZERO_OR_ONE, " Salesforce; not sure what the constrainst are "
    attribute :job_title, String, ZERO_OR_ONE, " Salesforce; free text "
    attribute :department, String, ZERO_OR_ONE, " Salesforce - department within org, rather than gov "
    attribute :address, :Address, ZERO_OR_ONE, " address of the contact point "
    attribute :phone, String, ZERO_TO_MANY, " phone of the contact point; salesforce only supports one "
    attribute :email, String, ZERO_TO_MANY, " email of the contact point; salesforce only supports two "
    attribute :origin, String, ZERO_OR_ONE, " from Salesforce - where the data was entered "
    attribute :notes, String, ZERO_OR_ONE, " from Salesforce "
    attribute :status, String, ZERO_OR_ONE, " from Salesforce, 'Active' "
    attribute :user_research_participane, String, ZERO_OR_ONE, " Y / N : from Salesforce " #TODO implement Boolean
    attribute :not_to_receive_ccs_emails, String, ZERO_OR_ONE, " Y / N : from Salesforce " #TODO implement Boolean
    attribute :contact_owner, String, ZERO_OR_ONE, " from Salesforce "
  }

}

