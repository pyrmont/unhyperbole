require 'spec_helper'

describe Unhyperbole do
  it "should be valid" do
    Unhyperbole.should be_a(Class)
  end

  context "when cleaning a chunk of markup" do

    # These chunks of markup are unwieldy; move them out to fixtures, and check those.
    let(:fixtures_path) { File.join(PROJECT_ROOT, 'spec', 'fixtures') }
    def get_file(filename)
      File.open(File.join(fixtures_path, filename)) { |f| f.read }.strip
    end
    def get_before(name)
      get_file "#{name}-before.txt"
    end
    def get_after(name)
      get_file "#{name}-after.txt"
    end
    def test_with_fixture(name)
      Unhyperbole.new(get_before(name)).unhyperbole.should == get_after(name)
    end

    it "should eliminate rhetorical questions" do
      test_with_fixture 'rhetorical'
    end
    it "should join two sentences together if the second begins with 'And'" do
      test_with_fixture 'double-sentence'
    end
    it "should remove sentences with less than three words in them" do
      test_with_fixture 'short-sentence'
    end

    pending "should remove sentences that begin with the phrase 'I love'"

    it "should remove sentences that consist entirely of 'They are the real deal.'" do
      test_with_fixture 'no-real-deal'
    end
    it "should remove the 'Yes, ' with which Siegler often beings a statement" do
      test_with_fixture 'the-big-yes'
    end
    it "should replace the 'But' at the beginning of a sentence with 'However'" do
      test_with_fixture 'but-sentence'
    end

  end
end
