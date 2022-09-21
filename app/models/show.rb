# frozen_string_literal: true

class Show < ApplicationRecord
  validates :name, :start_date, :finish_date, presence: true
  validates :finish_date, comparison: { greater_than_or_equal_to: :start_date }

  validate :validate_overlap

  scope :in_range, ->(sd, fd) { where('start_date >= ? AND finish_date <= ?', sd, fd) }

  private

  def validate_overlap
    return if errors.any?

    errors.add(:overlap_error, 'There is already a show scheduled in this period!') if Show.in_range(start_date, finish_date).any?
  end
end
