require File.join(File.dirname(__FILE__), "/../spec_helper")

describe Tag do
  fixtures :tags
  
  before(:each) do
    @tag = Tag.find 1
  end

  specify { Tag.should have_many :taggings}

  # These 2 show has_many_polymorphs works with seperate declarations
  specify { Tag.should have_many :contacts }
  specify { Tag.should have_many :comments }

  specify { Tag.should respond_to :roots }
  it { should respond_to :children }
  it { should respond_to :parent }
  
  it "should not allow deletion if unremovable" do    
    @tag.removable = false
    @tag.destroy.should be false
  end
  
  it "should tidy up orphaned objects" do
    pending
    parent = Tag.create
    child_id = parent.children.create.id
    parent.delete
    lambda { Tag.find child_id }.should raise_error
  end
  


  # should "act as list" do
  #   assert_respond_to @tag, :move_higher
  # end
  # 
  # should "act as tree" do
  #   assert_respond_to @tag, :children
  # end
  
  describe "validations" do
    
  end
  
  
end