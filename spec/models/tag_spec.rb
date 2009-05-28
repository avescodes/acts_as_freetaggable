require File.join(File.dirname(__FILE__), "/../spec_helper")

class Tag
  has_many_polymorphs :freetaggables, :from => [:contacts], :through => :taggings
  # # has_many polymorphs DOES work with seperate listings
  has_many_polymorphs :freetaggables, :from => [:comments], :through => :taggings
end

describe Tag do
  fixtures :tags

  context "model" do
    specify { Tag.should have_many :taggings}

    # These 2 show has_many_polymorphs works with seperate declarations
    specify { Tag.should have_many :contacts }
    specify { Tag.should have_many :comments }
  end

  context "instance" do
    it "should be able to give hierarchical title" do
      @tag_one.hierarchical_title.should == "Root -> tag 1.1"
    end
  end

  context "via association" do
    it "should be able to have tagged objects"
    it "should destroy properly through tagged objects"
    it "should still exist after tagged object is destroyed"
  end

  context "ordering" do
    #Through all the stuff I did I found that ordering requires #reloads to truly work as expected. Without them orderings don't come through properly
    it "should order roots by position" do
      root_positions = Tag.roots.map(&:position)
      lambda { root_positions.sort }.should_not change(root_positions, :first)
    end
    it "should order children by position" do
      children_positions = @root.children.map(&:position)
      lambda { children_positions.sort }.should_not change(children_positions, :first)
    end
    it "should order siblings by position" do
      @root.children.create # Add a third child to @root
      sibling_positions = @tag_two.siblings.map(&:position)
      lambda { sibling_positions.sort }.should_not change(sibling_positions, :first)
    end

    it "can reorder tags" do
      ids = @root.children.map(&:id)
      @root.children.first.move_down
      @root.reload
      @root.children.map(&:id).should_not be ids
      @root.children.second.move_up
      @root.reload
      # Check that each id is now the old id
      ids.each_with_index do |id, i|
        id.should be @root.children[i].id
      end
    end
    it "can reorder root tags" do
      ids = Tag.roots.map(&:id)
      tag_to_move = Tag.roots.second
      lambda {
        tag_to_move.move_up
      }.should change(tag_to_move, :position).from(2).to(1)
    end

    it "shouldn't move a tag with no siblings" do
      tag_to_move = @root2.children.first
      @root2.children.count.should be 1
      lambda { tag_to_move.move_up }.should_not change(tag_to_move, :position)
    end

    it { should respond_to :move_up }
    it "should change position of non-top tag when moved up" do
      tag_to_move = @root.children.second
      lambda { tag_to_move.move_up }.should change(tag_to_move, :position).from(2).to(1)
    end
    it "should change position of displaced tag when non-top tag is moved up" do
      tag_to_move = @root.children.second
      displaced_tag = @root.children.first
      lambda { tag_to_move.move_up; displaced_tag.reload }.should change(displaced_tag, :position).from(1).to(2)
    end
    it "should not move the top tag" do
      tag_to_move = @root.children.first
      lambda { tag_to_move.move_up }.should_not change(tag_to_move, :position)
    end

    it { should respond_to :move_down }
    it "should change position of non-bottom tag when moved down" do
      tag_to_move = @root.children.first
      lambda { tag_to_move.move_down }.should change(tag_to_move, :position)
    end
    it "should change position of displaced tag when non-bottom tag is moved down" do
      tag_to_move = @root.children.first
      displaced_tag = @root.children.second
      lambda { tag_to_move.move_down; displaced_tag.reload }.should change(displaced_tag, :position).from(2).to(1)
    end
    it "should not move the top tag" do
      tag_to_move = @root.children.last
      lambda { tag_to_move.move_down }.should_not change(tag_to_move, :position)
    end

    it "should be maintained through a mass assignment" do
      # i.e. [a,b] << [c,d] == [c,d,a,b] with objects in same order
      root_kids = @root.children
      root2_kids = @root2.children
      expected_root_kids = root2_kids + root_kids
      @root.children << @root2.children

      [@root,@root2].each(&:save).each(&:reload)

      @root2.children.count.should be 0
      @root.children.each_with_index do |child,i|
        child.id.should be expected_root_kids[i].id
      end
    end
  end

  context "tree" do
    subject { Tag }
    specify { should respond_to :roots }

    it "should tidy up orphaned objects" do
      # Note #delete does _NOT_ trigger children deletion
      parent = Tag.create!
      child_id = parent.children.create!.id
      grand_child_id = parent.children[0].children.create!.id
      parent.destroy
      lambda { Tag.find child_id }.should raise_error
      lambda { Tag.find grand_child_id }.should raise_error
    end
    it "should be capable of mass child reassignment" do
      root2_count = @root2.children.count
      root1_count = @root.children.count
      assert @root.children << @root2.children #don't put me in a lambda
      @root.should be_valid
      @root.save; @root.reload
      @root.children.count.should be root1_count + root2_count
    end
    it "node 'root' has 2 children" do
      @root.children.count.should be 2
    end
    it "node 'root' has 3 descendants" do
      @root.descendants.count.should be 3
    end
    it "node 'tag_one's parent is  node 'root'" do
      @tag_one.parent.should == @root
    end
    it "node 'tag_one' has 1 sibling" do
      @tag_one.siblings.count.should be 1
    end
    it "node 'tag_two_one' has 2 ancestors" do
      @tag_two_one.ancestors.count.should be 2
    end
  end

  context "tree node" do
    before(:each) do
      @tag = Tag.create
    end
    subject { @tag }
    it { should respond_to :children }
    it { should respond_to :descendants }
    it { should respond_to :parent }
    it { should respond_to :parent= }
    it { should respond_to :ancestors }
    it "cannot be its own parent" do
      @tag.parent = @tag
      @tag.should_not be_valid
    end
    it "can change parent" do
      @tag2 = Tag.create
      lambda { @tag.parent = @tag2 }.should_not raise_error
      @tag.parent.should == @tag2
    end
    it "can leave its parent and become root" do
      @tag2 = Tag.create
      @tag.parent = @tag2
      @tag.parent = nil
      @tag.save
      @tag.parent.should be nil
      Tag.roots.should include @tag
    end
    it "will be valid when #new'd and assigned own parent (but not yet saved)" do
      # Bug or feature? Can't assign parent properly unless id created
      @tag = Tag.new
      @tag.parent = @tag
      @tag.should be_valid
    end
    it "should not allow destruction if unremovable" do
      @tag.removable = false
      @tag.destroy.should be false
    end
  end

  describe "validations" do

  end


end
# Yet to be implemented from Cohort tag_test.rb
#==============================================
# context "Tags" do
#
#   context "with contacts" do
#     setup do
#       @contact = get_a_contact
#     end
#     should "be able to have a contact" do
#       assert @contact.tags.count == 0
#       @contact.tags = [@tag]
#       assert @contact.save
#       assert @contact.tags.count == 1
#     end
#
#     should "be able to delete tag" do
#       @contact.tags = [@tag]
#       @contact.save
#       assert @contact.tags.length == 1
#       assert @tag.destroy
#       @contact.reload
#       assert @contact.tags.length == 0
#     end
#
#     should "can delete a contact with a tag" do
#       @contact.tags = [@tag]
#       @contact.save
#       @contact.reload
#       assert @contact.destroy
#     end
#   end
# end
