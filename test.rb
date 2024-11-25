require 'minitest/autorun'
require_relative 'test'

class TestTest < Minitest::Test
    def test_example
        assert_equal 'expected', 'actual'
    end
end