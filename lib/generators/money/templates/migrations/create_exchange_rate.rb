class CreateExchangeRate < ActiveRecord::Migration
  def change
    create_table :exchange_rates do |t|
      t.integer :currency_id
      t.float :rate

      t.datetime :created_at 
    end

    add_index :exchange_rates, [:currency_id, :created_at], unique: true
  end
end
