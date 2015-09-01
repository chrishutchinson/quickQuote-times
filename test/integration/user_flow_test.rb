require 'test_helper'
# rake test test/integration/user_flow_test.rb
class UserFlowTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  test "can see the welcome page" do
    get "/"
    assert_select "h1", "quickQuote"
  end

end
