class CreateCalculatedExchangeRate < ActiveRecord::Migration
  def change
    create_table :calculated_exchange_rates do |t|
      t.integer :from_currency_id
      t.integer :to_currency_id
      t.float :rate

      t.datetime :created_at
      t.string :created_by
    end

    add_index :calculated_exchange_rates, [:from_currency_id, :created_at], unique: true, name: 'index_on_calculated_rate' 
  end
end
