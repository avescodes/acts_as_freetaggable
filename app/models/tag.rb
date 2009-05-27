class Tag < ActiveRecord::Base
  # Where things have gone/moved to
  # #validate no longer needed due to acts_as_category
  # before_destroy :forbid... is now before_destroy :removable?
  # #descendants replaces #get_all_children and #recurse_for_children
  # #ancestors replaces #my_parents and #recurse_for_parents
  
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

  def hierarchical_title 
    (ancestors.map(&:title) << self.title).join(' -> ')
  end
  
  private
  
end