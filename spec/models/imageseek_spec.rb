require 'spec_helper'

describe ImageSeek do
  it "is a daemon" do
    ImageSeek.daemon {
      true.should == false
    }
  end
end
