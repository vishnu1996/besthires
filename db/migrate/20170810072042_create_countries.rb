class CreateCountries < ActiveRecord::Migration
  def change
    create_table :countries do |t|
      t.text :display_name, null: false
      t.text :key, null: false
      t.boolean :default, default: false
      t.timestamps
    end

    add_index :countries, :display_name, unique: true
    add_index :countries, :key, unique: true
  end
end
