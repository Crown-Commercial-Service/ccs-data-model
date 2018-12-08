require_relative '../party'
require_relative '../agreement'


def load_all_examples(type)
  type.attributes.each_value do |a|
    begin
      if (nil != a[:example])
        self.send(a[:name], a[:example])
      end
    rescue
      print(" can't get example for #{type}, #{a[:name]}")
    end

  end
end

SAMPLE_PARTIES =
    Parties.new(:SampleParties) {
      NEW_PARTY = party {
        load_all_examples(self.class)

      }

      PATCH_PARTY = party {
        id NEW_PARTY.id
        org_name "New Org Name"
      }

      questionnaire {
        org_id NEW_PARTY.id
        org_id_standard NEW_PARTY.org_id_standard

        question_standards APPRENTICESHIP_QUALIFICATION_QUESTIONS.url

        question {
          classification "#{APPRENTICESHIP_QUALIFICATION_QUESTIONS.url}"
          answer_code "#{OFFSTED_RATING.example}"
        }
      }

      questionnaire {
        org_id NEW_PARTY.id
        org_id_standard NEW_PARTY.org_id_standard
        question_standards "SOME SECURITY QUESTIONS TBD" #TODO FIX

        question {
          classification "standard-for-security-TBD"
          answer_code "ISO/IEC:27001" #TODO iso standards
          supplementary_classification "some link to certification date start standard"
          supplementary_classification "some link to certification date end standard"
          supplementary_classification "some link to certification certificate standard"
          supplementary_field {
            role_id "date standard prefix :start"
            type_id "date"
            value { date _date(2019, 03, 01)}
          }
          supplementary_field {
            role_id "date standard prefix :end"
            type_id "date"
            # value { date _date(2021, 03, 01)}
          }
        }
      }

    }

SAMPLE_CONTACT =
    Parties.new(:SampleContacts) {
      contact {

        load_all_examples(self.class)
      }
    }