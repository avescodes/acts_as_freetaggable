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

  def move_up
  end

  def move_down
  end

  private

end
#
# class Tag < ActiveRecord::Base
#   include CohortArInstanceMixin
#   extend CohortArClassMixin
#   # Many validations are handled by the redhill schema_validations plugin.
#   has_many :log_items, :as => :item, :dependent => :destroy
#
#   def self.create_auto_tag(reason = 'Import')
#     Tag.create(:tag => "Autotag: #{reason} - #{Time.now.to_s(:long)}", :parent => self.get_autotag_root_tag)
#   end
#
#   def self.get_special_root_tag
#     self.find(:first, :conditions => ['tag = ? and parent_id is null','Special'])
#   end
#
#   def self.get_uncategorized_root_tag
#     self.find(:first, :conditions => ['tag = ? and parent_id is null','Uncategorized'])
#   end
#
#   def self.get_autotag_root_tag
#     self.find(:first, :conditions => ['tag = ? and parent_id =?','Autotags',self.get_special_root_tag.id])
#   end
#
#   def name_for_display
#     self.hierarchical_title
#   end
#
#   def self.select_options
#     tree = Tag.find(:all, :include => [ :children ], :order => :position)
#     options = [['-- root tag--',nil]]
#     self.recurse_for_select_options(tree,nil,0,options)
#     return options
#   end
#
#
#
#   def self.recurse_for_select_options(tree,parent_id,depth,options)
#     if parent_id == nil
#       depth = 0
#     else
#       depth += 1
#     end
#     tree.each do|node|
#       if node.parent_id == parent_id
#         options << [('_' * (depth * 2)).to_s + node.tag, node.id]
#           unless node.children.empty?
#             self.recurse_for_select_options(tree,node.id,depth,options)
#           end
#       end
#     end
#   end
