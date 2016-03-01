require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest

  test "layout links" do
    get root_path
    assert_template 'static_pages/home'
    assert_select "a[href=?]", root_path, count: 2 #并不是两次，而是有两个。一个logo，一个导航条
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", contact_path
    get signup_path
    assert_select "title", full_title("Sign up")
  end

  test "signup should has title" do
    get signup_path
    assert_response :success
    assert_select "title", "Sign up | Ruby on Rails Tutorial Sample App"
  end
end
