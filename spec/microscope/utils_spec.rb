require 'spec_helper'

describe Microscope::Utils do
  describe :ClassMethods do
    describe :past_participle_to_infinitive do
      before do
        Microscope.configure do |config|
          config.special_verbs = { 'started' => 'start', 'foo' => 'bar', 'canceled' => 'cancel' }
        end
      end

      let(:past_participles) { %w(liked loved gateway_canceled started fed foo) }
      let(:infinitives) { %w(like love gateway_cancel start feed bar) }
      let(:mapped_past_participles) { past_participles.map { |v| Microscope::Utils.past_participle_to_infinitive(v) } }

      specify do
        expect(mapped_past_participles).to eql infinitives
      end
    end
  end
end
