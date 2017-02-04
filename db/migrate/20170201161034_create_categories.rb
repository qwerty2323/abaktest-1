class CreateCategories < ActiveRecord::Migration
  def self.up
    unless table_exists?('categories')
      create_table :categories do |t|
        t.integer :parent_id
        t.string :title
        t.string :alias
        t.text :full_alias
        t.text :text

        t.timestamps
      end
    end
  end

  def self.down
    drop_table :categories
  end
end
