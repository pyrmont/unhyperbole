require 'spec_helper'

describe Unhyperbole do
  it "should be valid" do
    Unhyperbole.should be_a(Class)
  end

  context "when cleaning a chunk of markup" do

    pending "should eliminate rhetorical questions"
    pending "should join two sentences together if the second begins with 'And'"
    pending "should remove sentences with less than three words in them"
    pending "should remove sentences that begin with the phrase 'I love'"
    pending "should remove sentences that consist entirely of 'They are the real deal.'"
    pending "should remove the 'Yes, ' with which Siegler often beings a statement"
    pending "should replace the 'But' at the beginning of a sentence with 'However'"

  end
end
