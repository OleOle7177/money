class CreateCurrency < ActiveRecord::Migration
  def change
    create_table :currencies do |t|
      t.string :name
      t.string :code
      t.string :symbol 
      t.boolean :is_base, default: false

      t.timestamps
    end

    add_index :currencies, :is_base
    add_index :currencies, :code, unique: true
  end
end
