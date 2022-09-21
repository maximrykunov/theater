# frozen_string_literal: true

class CreateShows < ActiveRecord::Migration[7.0]
  def change
    create_table :shows do |t|
      t.string :name
      t.date :start_date
      t.date :finish_date

      t.timestamps
    end
  end
end
