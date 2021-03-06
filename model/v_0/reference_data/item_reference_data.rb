require_relative '../reference_data'

ReferenceData.new :ItemStandard do
  ITEM_STANDARDS = Enum (standardlist {
    macro &ID_AND_URL_FROM_DOMAIN_AND_VERSION
    title "ItemClassificationStandards"
    description "Standard of codes used to decide what standard to use to classify an item"
    CPV= standard {
      id :cpv
      macro &URI_FROM_DOC_AND_ID
      title "EC Common Procurement Vocabulary"
      description "The Common Procurement Vocabulary is a standard adopted by the Commission of the European Community, and consisting of a main vocabulary for defining the subject of a contract, and a supplementary vocabulary for adding further qualitative information. The main vocabulary, identified in OCDS by the code CPV, is based on a tree structure comprising codes of up to 9 digits (an 8 digit code plus a check digit) associated with a wording that describes the type of supplies, works or services forming the subject of the contract. Codes may be provided with or without the check digit, and consuming applications should be aware of this when processing data with CPV codes.	"
      source "http://simap.ted.europa.eu/web/simap/cpv"
    }
    standard {
      id :cpvs
      macro &URI_FROM_DOC_AND_ID
      title "EC Common Procurement Vocabulary - Supplementary Codelists"
      description "The Common Procurement Vocabulary is a standard adopted by the Commission of the European Community, and consisting of a main vocabulary for defining the subject of a contract, and a supplementary vocabulary for adding further qualitative information. The supplementary vocabulary, identified in OCDS by the code CPVS, is made up of an alphanumeric code with a corresponding wording allowing further details to be added regarding the specific nature or destination of the goods to be purchased.	"
      source "http://simap.europa.eu/codes-and-nomenclatures/codes-cpv/codes-cpv_en.htm"
    }
    standard {
      id :gsin
      macro &URI_FROM_DOC_AND_ID
      title "Goods and Services Identification Number"
      description "The Canadian federal government uses Goods and Services Identification Number (GSIN) codes to identify generic product descriptions for its procurement activities. The full list is published and maintained at buyandsell.gc.ca	"
      source "https://buyandsell.gc.ca/procurement-data/goods-and-services-identification-number"
    }
    standard {
      id :unspsc
      macro &URI_FROM_DOC_AND_ID
      title "United Nations Standard Products and Services Code	"
      description "The United Nations Standard Products and Services Code (UNSPSC) is a hierarchical convention that is used to classify all products and services. Machine readable metadata for UNSPSC is not provided as open data: and so publishers should consider alternative classification standards that do provide open data lookup tables wherever possible.	"
      source "http://www.unspsc.org/codeset-downloads"
    }
    standard {
      id :cpc
      macro &URI_FROM_DOC_AND_ID
      title "Central Product Classification	"
      description "The Central Product Classification (CPC) is a product classification for goods and services promulgated by the United Nations Statistical Commission. It is intended to be an international standard for organizing and analyzing data on industrial production, national accounts, trade and prices	"
      source "http://unstats.un.org/unsd/cr/registry/cpc-21.asp"
    }
  })
end

