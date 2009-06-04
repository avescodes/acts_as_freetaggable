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

  context "associated object" do
    before (:each) do
      @object = Contact.create
      @object.tags << @root
    end
    subject { @object }
    it { should respond_to :tags }
    it "should be able to have tags" do
      lambda { @object.tags << Tag.create }.should change(@object.tags, :count).by(1)
    end
    it "should update when a tag is destroyed" do
      @root.destroy
      @object.tags.count.should be 0
    end
    it "should leave tag intact after themselves being destroyed" do
      tag_id = @root.id
      @object.destroy
      lambda { Tag.find tag_id }.should_not raise_error
    end
  end

  describe "validations" do

  end


end