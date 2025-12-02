require "test_helper"

class WeeklyReportsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get weekly_reports_index_url
    assert_response :success
  end

  test "should get show" do
    get weekly_reports_show_url
    assert_response :success
  end
end
