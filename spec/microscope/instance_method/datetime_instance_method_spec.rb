require 'spec_helper'

describe Microscope::InstanceMethod::DatetimeInstanceMethod do
  before do
    Microscope.configure do |config|
      config.special_verbs = { 'started' => 'start' }
    end

    run_migration do
      create_table(:events, force: true) do |t|
        t.datetime :started_at, default: nil
      end
    end

    microscope 'Event'
  end

  describe '#started?' do
    context 'with positive result' do
      let(:event) { Event.create(started_at: 2.months.ago) }
      it { expect(event).to be_started }
    end

    context 'with negative result' do
      let(:event) { Event.create(started_at: 1.month.from_now) }
      it { expect(event).to_not be_started }
    end
  end

  describe '#started=' do
    before { event.started = value }

    context 'with blank argument' do
      let(:event) { Event.create(started_at: 2.months.ago) }
      let(:value) { '0' }

      it { expect(event).to_not be_started }
    end

    context 'with present argument' do
      let(:event) { Event.create }
      let(:value) { '1' }

      it { expect(event).to be_started }
    end

    context 'with present argument, twice' do
      let(:event) { Event.create(started_at: time) }
      let(:time) { 2.months.ago }
      let(:value) { '1' }

      it { expect(event.started_at).to eql time }
    end
  end

  describe '#not_started?' do
    context 'with negative result' do
      let(:event) { Event.create(started_at: 2.months.ago) }
      it { expect(event).to_not be_not_started }
      it { expect(event).to respond_to(:unstarted?) }
    end

    context 'with positive result' do
      let(:event) { Event.create(started_at: 1.month.from_now) }
      it { expect(event).to be_not_started }
    end
  end

  describe '#start!' do
    let(:stubbed_date) { Time.parse('2020-03-18 08:00:00') }
    before { Time.stub(:now).and_return(stubbed_date) }

    let(:event) { Event.create(started_at: nil) }
    it { expect { event.start! }.to change { event.reload.started_at }.from(nil).to(stubbed_date) }
  end

  describe '#not_start!' do
    let(:stubbed_date) { Time.parse('2020-03-18 08:00:00') }

    let(:event) { Event.create(started_at: stubbed_date) }
    it { expect { event.not_start! }.to change { event.reload.started_at }.from(stubbed_date).to(nil) }
    it { expect(event).to respond_to(:unstart!) }
  end
end
