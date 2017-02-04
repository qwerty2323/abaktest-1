class RenameColCategoryFullAlias < ActiveRecord::Migration
  def up
    rename_column :categories, :full_alias, :url
  end

  def down
    rename_column :categories, :url, :full_alias
  end
end
