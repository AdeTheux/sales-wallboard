require 'test_helper'

class IframesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @iframe = iframes(:one)
  end

  test "should get index" do
    get iframes_url
    assert_response :success
  end

  test "should get new" do
    get new_iframe_url
    assert_response :success
  end

  test "should create iframe" do
    assert_difference('Iframe.count') do
      post iframes_url, params: { iframe: { department: @iframe.department, title: @iframe.title, url: @iframe.url } }
    end

    assert_redirected_to iframe_url(Iframe.last)
  end

  test "should show iframe" do
    get iframe_url(@iframe)
    assert_response :success
  end

  test "should get edit" do
    get edit_iframe_url(@iframe)
    assert_response :success
  end

  test "should update iframe" do
    patch iframe_url(@iframe), params: { iframe: { department: @iframe.department, title: @iframe.title, url: @iframe.url } }
    assert_redirected_to iframe_url(@iframe)
  end

  test "should destroy iframe" do
    assert_difference('Iframe.count', -1) do
      delete iframe_url(@iframe)
    end

    assert_redirected_to iframes_url
  end
end
