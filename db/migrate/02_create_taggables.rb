class CreateTaggables < ActiveRecord::Migration
  def self.up
    create_table :contacts do |t|
      t.timestamps
    end
    create_table :comments do |t|
      t.timestamps
    end
  end

  def self.down
    drop_table :contacts
    drop_table :comments
  end
end
class CreateComments < ActiveRecord::Migration
  def self.up

  end

  def self.down

  end
end
