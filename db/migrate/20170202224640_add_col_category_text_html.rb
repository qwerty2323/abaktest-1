class AddColCategoryTextHtml < ActiveRecord::Migration
  def up
    add_column :categories, :text_html, :text, after: :text
  end

  def down
    remove_column :categories, :text_html
  end
end
