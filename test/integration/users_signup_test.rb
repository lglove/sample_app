require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  test "use_signup_form_should_right" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, user: {
        name: "  ", email: "user@invalid..com",
        password: "hijai", password_confirmation: "hai"
      }
    end
    assert_template 'users/new'
  end

  test "valid signup information" do
    get signup_path
    name = "Example User"
    email = "user@example.com"
    password = "password"
    assert_difference 'User.count', 1 do
      post_via_redirect users_path, user: { name: name, email: email,
        password: password, password_confirmation: password
      }
      assert_template '/'
      assert is_logged_in?
      assert_not flash.empty?
    end
  end
end
