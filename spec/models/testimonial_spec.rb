require File.dirname(__FILE__) + '/../spec_helper'

describe Banner do
  before(:each) do
    @project = Banner.new
  end

  it "should be valid" do
    @project.should be_valid
  end
end
