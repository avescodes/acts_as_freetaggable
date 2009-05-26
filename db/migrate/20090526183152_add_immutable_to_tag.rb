class AddImmutableToTag < ActiveRecord::Migration
  def self.up
    add_column :tags, :removable, :boolean, :default => true
  end

  def self.down
    remove_column :tags, :removable
  end
end
