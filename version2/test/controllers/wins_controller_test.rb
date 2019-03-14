require 'test_helper'

class WinsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @win = wins(:one)
  end

  test "should get index" do
    get wins_url
    assert_response :success
  end

  test "should get new" do
    get new_win_url
    assert_response :success
  end

  test "should create win" do
    assert_difference('Win.count') do
      post wins_url, params: { win: { agents: @win.agents, company: @win.company, mrr: @win.mrr, reps: @win.reps } }
    end

    assert_redirected_to win_url(Win.last)
  end

  test "should show win" do
    get win_url(@win)
    assert_response :success
  end

  test "should get edit" do
    get edit_win_url(@win)
    assert_response :success
  end

  test "should update win" do
    patch win_url(@win), params: { win: { agents: @win.agents, company: @win.company, mrr: @win.mrr, reps: @win.reps } }
    assert_redirected_to win_url(@win)
  end

  test "should destroy win" do
    assert_difference('Win.count', -1) do
      delete win_url(@win)
    end

    assert_redirected_to wins_url
  end
end
