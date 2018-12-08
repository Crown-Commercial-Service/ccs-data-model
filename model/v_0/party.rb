require_relative '../../src/data_model'
require_relative 'supplementary'
require_relative 'register'
require_relative 'documents'

require_relative 'reference_data/party_reference_data'
require_relative 'reference_data/supplementary_reference_data'
include DataModel

domain(:Parties) {

  datatype(:Question,
           description: "A managed set of qualification questions andwered at a point in time for a period of time") {

    attribute :classification, String, SINGLE, "coded answers to questions matching the standards",
              example: "#{APPRENTICESHIP_QUALIFICATION_QUESTIONS.url}"
    attribute :answer_code, String, ZERO_OR_ONE, "coded answers to questions matching the standards",
              example: "#{OFFSTED_RATING.example}"
    attribute :supplementary_classification, String, ZERO_TO_MANY, "coded answers to questions matching the standards",
              example: "#{APPRENTICESHIP_QUALIFICATION_QUESTIONS.url}"
    attribute :supplementary_field, Supplementary::Field, ZERO_TO_MANY,
              "additional filters used to qulify the item. Filter standards should obviously be relevant to the item"
    attribute :document, Documents::Document
  }

  datatype(:Questionnaire, extends: Register::Record,
           description: "A managed set of qualification questions andwered at a point in time for a period of time") {

    attribute :id, String, "UUID for the questionnaire entry", example: "uuid"
    attribute :org_id, String, " such as URN; could match salesforce ID; master key ", example: SF_ORG.example
    attribute :org_id_standard, ORG_ID_STANDARDS, example: SF_ORG.uri
    attribute :completed, Date, example: "2018-7-7"
    attribute :expires, Date, example: "2020-7-6"
    attribute :question_standards, String, ZERO_TO_MANY, "The coding standards for the questions and answers",
              example: APPRENTICESHIP_QUALIFICATION_QUESTIONS.url
    attribute :question, :Question, ZERO_TO_MANY, "coded answers to questions matching the standards"
  }

  datatype(:Party, description:
      "The party is used to identify buyers and suppliers. Since some organisations act as" +
          "both buyers and suppliers we use the same record for both, but most organisations will" +
          "be one or the other. The onvolvement of the party with an agreement determine the role in" +
          "that contenxt.") {
    attribute :id, String, " such as URN; could match salesforce ID; master key ", example: SF_ORG.example
    attribute :org_id_standard, ORG_ID_STANDARDS, example: SF_ORG.uri
    attribute :supplementary_org_id_standard, ORG_ID_STANDARDS, ZERO_TO_MANY, example: CH_ORG.uri
    attribute :supplementary_org_id, String, ZERO_TO_MANY, example: CH_ORG.example
    attribute :parent_org_id, String, ZERO_OR_ONE, " URN, should match one of the standards listed ", links: :Party,
              example: "#{CH_ORG.prefix}:78901"
    attribute :org_name, String, "interesting organisation"
    attribute :sector_standard, SECTOR_STANDARDS, ZERO_TO_MANY, example: CCSSECTORS.url
    attribute :sector, String, ZERO_TO_MANY, example: ED_SEC.example
    attribute :trading_name, String, ZERO_OR_ONE, " Salesforce only stores for supplier. "
    attribute :spend_this_year, Float, ZERO_OR_ONE, " Salesforce only stores this for buyers. ", example: 1000.00

    attribute :contact_standard, CONTACT_ID_STANDARDS, ZERO_OR_ONE, example: SF_CONTACT.uri
    attribute :account_manager_id, String, ZERO_OR_ONE, " Who manages the account for CCS ", example: SF_CONTACT.example
  }

  datatype(:Address, description: "
 Address should include at least address line 1 and ideally post code.
 will contain lat / long if we have derived it.
 ") {
    attribute :street, String, ZERO_OR_ONE, example: "1 fogg street"
    attribute :address_2, String, ZERO_OR_ONE, example: ""
    attribute :town, String, ZERO_OR_ONE, example: "London"
    attribute :county, String, ZERO_OR_ONE
    attribute :country, String, ZERO_OR_ONE
    attribute :postcode, String, ZERO_OR_ONE, example: "SW1 1HQ"
    attribute :latitutde, String, ZERO_OR_ONE, " Location from the address for geo search "
    attribute :longtitude, String, ZERO_OR_ONE, " Location from the address for geo search "
  }

  datatype(:Contact, description:
      "A way of contacting a party. Store contacts in a safe identity store. Do not store personal details elsewhere. ") {
    attribute :contact_standard, CONTACT_ID_STANDARDS, SINGLE, example: SF_CONTACT.uri
    attribute :id, String, " a newly minted UUID for CMp "
    attribute :supplementary_contact_standard, CONTACT_ID_STANDARDS, ZERO_TO_MANY
    attribute :supplementary_contact_id, String, ZERO_TO_MANY

    attribute :org_id_standard, ORG_ID_STANDARDS, example: SF_ORG.uri
    attribute :party_id, String, " contact is a link for this party ", links: :Party, example: SF_ORG.example

    attribute :role, CONTACT_ROLES, ZERO_TO_MANY, " role for CMp ", example: ADMIN.example
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
    attribute :user_research_participant, String, ZERO_OR_ONE, " Y / N : from Salesforce " #TODO implement Boolean
    attribute :not_to_receive_ccs_emails, String, ZERO_OR_ONE, " Y / N : from Salesforce " #TODO implement Boolean
    attribute :contact_owner, String, ZERO_OR_ONE, " from Salesforce "
    attribute :org_structure_standard, ORG_STRUCT_STANDARDS, "Standard identifying prefixes for organisation responbsible for this agreement. ", example: CCS_ORG_CODES.doc.url
    attribute :org_unit, String, ONE_TO_MANY, "Category org unit responsible for this agreement. ", example: "#{CCS_ORG_CODES.id}#{BUILDINGS.id}"
  }

}

