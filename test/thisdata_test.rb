require 'test_helper'

class ThisdataTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Thisdata::VERSION
  end
end
