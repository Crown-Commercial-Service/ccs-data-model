require_relative '../../model/v_0/reference_data/documents_reference_data'

domain(:Documents) {

  datatype(:Document) {
    attribute :storage, DOC_STORAGE_TYPES, ZERO_OR_ONE, example: GDOC.uri
    attribute :role_standard, DOC_ROLE_STANDARDS, ZERO_TO_MANY, example: SIGNED_CONTRACTS.uri
    attribute :role, String, ZERO_TO_MANY, example: SIGNED_CONTRACTS.example
    attribute :url, String, SINGLE, " Salesforce links to google drive folder for this supplier; we will move to S3 in due course. ",
              example: "gdoc:https://drive.google.com/drive/u/012345"
  }
}