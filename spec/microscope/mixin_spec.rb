require 'spec_helper'

describe Microscope::Mixin do
  describe :acts_as_microscope do
    subject { User }

    before do
      run_migration do
        create_table(:users, force: true) do |t|
          t.boolean :active, default: false
          t.boolean :admin, default: false
          t.boolean :moderator, default: false
        end
      end
    end

    describe :except do
      before do
        microscope 'User', except: [:admin]
      end

      it { should respond_to :active }
      it { should respond_to :not_active }
      it { should respond_to :moderator }
      it { should respond_to :not_moderator }
      it { should_not respond_to :admin }
      it { should_not respond_to :not_admin }
    end

    describe :only do
      before do
        microscope 'User', only: [:admin]
      end

      it { should_not respond_to :active }
      it { should_not respond_to :not_active }
      it { should_not respond_to :moderator }
      it { should_not respond_to :not_moderator }
      it { should respond_to :admin }
      it { should respond_to :not_admin }
    end

    describe 'except and only' do
      before do
        microscope 'User', only: [:admin], except: [:active]
      end

      it { should_not respond_to :active }
      it { should_not respond_to :not_active }
      it { should_not respond_to :moderator }
      it { should_not respond_to :not_moderator }
      it { should respond_to :admin }
      it { should respond_to :not_admin }
    end
  end

  describe 'Boolean scopes' do
    subject { User }

    before do
      run_migration do
        create_table(:users, force: true) do |t|
          t.boolean :active, default: false
        end
      end

      microscope 'User'
    end

    describe 'positive scope' do
      before { @user1 = User.create(active: true) }

      its(:active) { should have(1).items }
      its(:active) { should include(@user1) }
      its(:not_active) { should be_empty }
    end

    describe 'negative scope' do
      before { @user1 = User.create(active: false) }

      its(:not_active) { should have(1).items }
      its(:not_active) { should include(@user1) }
      its(:active) { should be_empty }
    end
  end

  describe 'DateTime scopes' do
    subject { Event }

    before do
      run_migration do
        create_table(:events, force: true) do |t|
          t.datetime :started_at, default: nil
        end
      end

      microscope 'Event'
    end

    describe 'before scope' do
      before do
        @event = Event.create(started_at: 2.months.ago)
        Event.create(started_at: 1.month.from_now)
      end

      it { expect(Event.started_before(1.month.ago).to_a).to eql [@event] }
    end

    describe 'before_now scope' do
      before do
        @event = Event.create(started_at: 2.months.ago)
        Event.create(started_at: 1.month.from_now)
      end

      it { expect(Event.started_before_now.to_a).to eql [@event] }
    end

    describe 'after scope' do
      before do
        @event = Event.create(started_at: 2.months.from_now)
        Event.create(started_at: 1.month.ago)
      end

      it { expect(Event.started_after(1.month.from_now).to_a).to eql [@event] }
    end

    describe 'after_now scope' do
      before do
        @event = Event.create(started_at: 2.months.from_now)
        Event.create(started_at: 1.month.ago)
      end

      it { expect(Event.started_after_now.to_a).to eql [@event] }
    end

    describe 'between scope' do
      before do
        Event.create(started_at: 1.month.ago)
        @event = Event.create(started_at: 3.months.ago)
        Event.create(started_at: 5.month.ago)
      end

      it { expect(Event.started_between(4.months.ago..2.months.ago).to_a).to eql [@event] }
    end

    describe 'super-boolean positive scope', focus: true do
      before do
        @event1 = Event.create(started_at: 1.month.ago)
        @event2 = Event.create(started_at: 3.months.ago)
        Event.create(started_at: 2.months.from_now)
        Event.create(started_at: nil)
      end

      it { expect(Event.started.to_a).to eql [@event1, @event2] }
    end

    describe 'super-boolean negative scope' do
      before do
        Event.create(started_at: 1.month.ago)
        Event.create(started_at: 3.months.ago)
        @event1 = Event.create(started_at: 2.months.from_now)
        @event2 = Event.create(started_at: nil)
      end

      it { expect(Event.not_started.to_a).to eql [@event1, @event2] }
    end
  end

  describe 'Date scopes' do
    subject { Event }

    before do
      run_migration do
        create_table(:events, force: true) do |t|
          t.date :started_on, default: nil
        end
      end

      microscope 'Event'
    end

    describe 'before scope' do
      before do
        @event = Event.create(started_on: 2.months.ago)
        Event.create(started_on: 1.month.from_now)
      end

      it { expect(Event.started_before(1.month.ago).to_a).to eql [@event] }
    end

    describe 'before_today scope' do
      before do
        @event = Event.create(started_on: 2.months.ago)
        Event.create(started_on: 1.month.from_now)
      end

      it { expect(Event.started_before_today.to_a).to eql [@event] }
    end

    describe 'after scope' do
      before do
        @event = Event.create(started_on: 2.months.from_now)
        Event.create(started_on: 1.month.ago)
      end

      it { expect(Event.started_after(1.month.from_now).to_a).to eql [@event] }
    end

    describe 'after_today scope' do
      before do
        @event = Event.create(started_on: 2.months.from_now)
        Event.create(started_on: 1.month.ago)
      end

      it { expect(Event.started_after_today.to_a).to eql [@event] }
    end

    describe 'between scope' do
      before do
        Event.create(started_on: 1.month.ago)
        @event = Event.create(started_on: 3.months.ago)
        Event.create(started_on: 5.month.ago)
      end

      it { expect(Event.started_between(4.months.ago..2.months.ago).to_a).to eql [@event] }
    end

    describe 'super-boolean positive scope' do
      before do
        @event1 = Event.create(started_on: 1.month.ago)
        @event2 = Event.create(started_on: 3.months.ago)
        Event.create(started_on: 2.months.from_now)
      end

      it { expect(Event.started.to_a).to eql [@event1, @event2] }
    end

    describe 'super-boolean negative scope' do
      before do
        Event.create(started_on: 1.month.ago)
        Event.create(started_on: 3.months.ago)
        @event1 = Event.create(started_on: 2.months.from_now)
      end

      it { expect(Event.not_started.to_a).to eql [@event1] }
    end
  end
end
