require File.join(File.dirname(__FILE__), "/../spec_helper")

if defined?(Comment) and defined?(Contact)
  class Tag
    has_many_polymorphs :freetaggables, :from => [:contacts], :through => :taggings
    # # has_many polymorphs DOES work with seperate listings
    has_many_polymorphs :freetaggables, :from => [:comments], :through => :taggings
  end
end

describe Tag do
  context "model" do
    specify { Tag.should have_many :taggings}

    # These 2 show has_many_polymorphs works with seperate declarations
    if defined?(Comment) and defined?(Contact)
      specify { Tag.should have_many :contacts }
      specify { Tag.should have_many :comments }
      context "associated object" do
        before (:each) do
          @object = Contact.create
          @root = Tag.create(:title => 'root')
          @object.tags << @root
        end
        subject { @object }
        it { should respond_to :tags }
        it "should be able to have tags" do
          lambda { @object.tags << Tag.create(:title => "title") }.should change(@object.tags, :count).by(1)
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
    end
  end

  context "instance" do
    it "should be able to give hierarchical title" do
      root = Tag.create(:title => 'Root')
      one = Tag.create(:title => 'tag 1.1')
      root.children << one
      one.reload
      one.hierarchical_title.should == "Root -> tag 1.1"
    end
  end

  describe "validations" do
    it { Tag.new.should validate_presence_of :title }
    it { Tag.new.should validate_length_of :title, :maximum => 200 }
    it { Tag.new(:title => 'hi').should validate_length_of :description, :maximum => 1000 }
  end


end
