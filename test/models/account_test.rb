require 'test_helper'

class AccountTest < ActiveSupport::TestCase
  test "the truth" do
    assert accounts(:one).domain
  end
end
