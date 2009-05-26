require File.join(File.dirname(__FILE__), "/../spec_helper")

describe Tag do
  fixtures :tags
  
  before(:each) do
    @tag = Tag.find 1
  end

  specify { Tag.should have_many :taggings}
  it "should not fail on before(:each)" do
  end
  describe "validations" do
  end
  
  
end