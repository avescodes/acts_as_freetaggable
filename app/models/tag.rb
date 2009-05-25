class Tag < ActiveRecord::Base
  acts_as_category
  has_many_polymorphs :freetaggables, :from => [:contacts], :through => :taggings
  has_many_polymorphs :freetaggables, :from => [:comments], :through => :taggings
end