require 'test_helper'

class ContentControllerTest < ActionDispatch::IntegrationTest
  setup do
    @content = contents(:one)
  end

  test "should get index" do
    get content_index_url
    assert_response :success
  end

  test "should create content" do
    assert_difference('Content.count') do
      post content_index_url,
        headers: {
          Authorization: tokens(:one).id
        },
        params: { content: {
          sha256: "12345",
          mime_type: "application/yolo",
          size: 10
        } }
    end

    assert_redirected_to content_url(Content.last)
  end

  test "should show content" do
    get content_url(@content)
    assert_response :success
  end

end
