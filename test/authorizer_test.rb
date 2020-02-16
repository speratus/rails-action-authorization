require 'test_helper'

class Authorizer::Test < ActiveSupport::TestCase
  test "truth" do
    assert_kind_of Module, Authorizer
  end

  test "ensures authorized? is added" do
    assert_respond_to(User.new, :authorized?)
  end

  test "ensures get_perms is added" do
    assert_respond_to(User, :get_perms)
  end

  test "ensures check_perm is added" do
    assert_respond_to(User, :check_perm)
  end

  test "adds instance method" do 
    assert_respond_to(PostsController.new, :check_authorization)
  end

  test "can add a single check" do
    User.check_perm('test') {|u, r| true}
    user = User.new
    assert_equal user, user.authorized?('test', nil)
  end

  test "can add multiple checks" do
    test_names = ['test', 'test2', 'test3']
    User.check_perm(*test_names) {|u, r| true}
    user = User.new
    test_names.each do |n|
      assert_equal user, user.authorized?(n, nil)
    end
  end
end
