require 'spec_helper'
require 'byebug'

describe Mail2FrontMatter::PreProcessor, "registration" do

  let(:invalidly_defined_preprocessor) { 
    class MyInvalidProcessor < Mail2FrontMatter::PreProcessor
      # note, instanced not class
      def run(metadata, body)
        # some modification
        return metadata, body
      end
    end

    return MyInvalidProcessor
  }

  let(:validly_defined_preprocessor) { 
    class MyValidProcessor < Mail2FrontMatter::PreProcessor
      def self.run(metadata, body)
        # some modification
        return metadata, body
      end
    end

    return MyValidProcessor
  }

  it "should raise errors for invalid processors" do
    expect {
      invalidly_defined_preprocessor.register({})
    }.to raise_error
  end

  it "should not raise errors for valid processors" do
    expect {
      validly_defined_preprocessor.register({})
    }.to_not raise_error
  end

end