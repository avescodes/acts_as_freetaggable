class Tag < ActiveRecord::Base
  acts_as_category
  has_many_polymorphs :freetaggables, :from => [:contacts], :through => :taggings
  # has_many polymorphs DOES work with seperate listings
  has_many_polymorphs :freetaggables, :from => [:comments], :through => :taggings
  
  before_destroy :removable?
#  before_destroy delete children

  def removable?
    self.removable
  end

end