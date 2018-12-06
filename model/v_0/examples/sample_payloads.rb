require_relative '../party'
require_relative '../agreement'


def load_all_samples(type)
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
        load_all_samples(self.class)
        questionnaire {
          load_all_samples(self.class)
        }
      }

      PATCH_PARTY= party {
        id NEW_PARTY.id
        org_name "New Org Name"
      }

    }

SAMPLE_CONTACT=
    Parties.new(:SampleContacts){

    }