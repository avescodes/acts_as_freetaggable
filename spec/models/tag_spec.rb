require File.join(File.dirname(__FILE__), "/../spec_helper")

describe Tag do
  specify { Tag.should have_many :taggings}
  before(:all) do
    
  end
  
  describe "validations" do
  end
end