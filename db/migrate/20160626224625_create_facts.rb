class CreateFacts < ActiveRecord::Migration
  def change
    create_table :facts do |t|
      t.references :asset, index: true, foreign_key: true
      t.string :predicate, :null => false
      t.string :object, :null => true
      t.boolean :literal, :default => true, :null => false
      t.integer :to_add_by, :default => nil, :null => true
      t.integer :to_remove_by, :default => nil, :null => true
      t.timestamps null: false
    end
  end
end
