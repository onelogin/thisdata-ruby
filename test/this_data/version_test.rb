require_relative "../test_helper.rb"

class ThisData::VersionTest < ThisData::UnitTest
  def test_that_it_has_a_version_number
    refute_nil ::ThisData::VERSION
  end
end
