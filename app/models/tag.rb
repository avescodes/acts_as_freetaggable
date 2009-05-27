class Tag < ActiveRecord::Base
  # Where things have gone/moved to
  # #validate no longer needed due to acts_as_category
  # before_destroy :forbid... is now before_destroy :removable?
  # 
  
  acts_as_category

  # Polymorphic associations are added via this call. 
  # This call will get wrapped in acts_as_freetaggable call when pluginized
  # has_many_polymorphs :freetaggables, :from => [:contacts], :through => :taggings
  # # has_many polymorphs DOES work with seperate listings
  # has_many_polymorphs :freetaggables, :from => [:comments], :through => :taggings
  
  before_destroy :removable?

  def removable?
    self.removable
  end

  private
  
end