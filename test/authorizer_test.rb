require 'test_helper'

class Authorizer::Test < ActiveSupport::TestCase
  test "truth" do
    assert_kind_of Module, Authorizer
  end

  test "ensures authorized? is added" do
    assert_respond_to(User, :authorized?)
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
end
