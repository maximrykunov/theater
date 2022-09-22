# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Show, type: :model do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:start_date) }
  it { should validate_presence_of(:finish_date) }

  describe 'comparison dates' do
    let(:show) { build :show }

    context 'start_date is less than finish_date' do
      it 'not return the error' do
        expect(show).to be_valid
      end
    end

    context 'finish_date is less than start_date' do
      before do
        show.finish_date = show.start_date - 1.day
      end

      it 'return the error' do
        expect(show).to be_invalid
        expect(show.errors[:finish_date]).to include('must be greater than or equal to 2022-01-01')
      end
    end
  end

  describe '#validate_overlap' do
    let!(:initial_show) { create(:show) }
    let(:show) { build :show }

    context 'existing show is inside new' do
      before do
        show.start_date = initial_show.start_date - 2.days
        show.finish_date = initial_show.finish_date + 2.day
      end

      it 'return the error' do
        expect(show).to be_invalid
        expect(show.errors[:overlap_error]).to include('There is already a show scheduled in this period!')
      end
    end

    context 'new show is inside existing show' do
      before do
        show.start_date = initial_show.start_date + 2.days
        show.finish_date = initial_show.finish_date - 2.day
      end

      it 'return the error' do
        expect(show).to be_invalid
        expect(show.errors[:overlap_error]).to include('There is already a show scheduled in this period!')
      end
    end

    context 'start_date is overlaping' do
      before do
        show.start_date = initial_show.finish_date
        show.finish_date = initial_show.finish_date + 1.day
      end

      it 'return the error' do
        expect(show).to be_invalid
        expect(show.errors[:overlap_error]).to include('There is already a show scheduled in this period!')
      end
    end

    context 'finish_date is overlaping' do
      before do
        show.start_date = initial_show.start_date - 1.day
        show.finish_date = initial_show.start_date
      end

      it 'return the error' do
        expect(show).to be_invalid
        expect(show.errors[:overlap_error]).to include('There is already a show scheduled in this period!')
      end
    end

    context 'date is not overlaping' do
      before do
        show.start_date = initial_show.start_date - 2.days
        show.finish_date = initial_show.start_date - 1.day
      end

      it 'not return the error' do
        expect(show).to be_valid
      end
    end
  end
end
