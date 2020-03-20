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

  test 'can authorize many at a time' do
    Post.check_perm('test') {|u, r| true}
    user = User.new
    posts = []
    5.times do
      posts << Post.new
    end
    # puts "-------------"
    # puts "About to create Resource"
    r = ActionAuthorization::Resource.new('test', user, *posts)
    # puts "Verifying resource"
    assert_equal posts, r.get
  end

  test 'can filter resources' do
    Post.check_perm('test') {|p, r| [true, false].sample }

    posts = []
    9.times do
      posts << Post.new
    end

    r = ActionAuthorization::Resource.new('test', nil, *posts, behavior: :filter)
    assert_operator posts.length, :>, r.get.length
  end

  test 'returns resources if resources is an empty array' do
    Post.check_perm('test') {|p, r| true}
    posts = []
    r = ActionAuthorization::Resource.new('test', nil, *posts)
    assert_equal posts, r.get
  end

  test 'returns all resources even when some are not authorized' do
    Post.check_perm('test') {|p, r| p.content != 'no'}
    posts = []

    5.times do
      posts << Post.new(content: 'yes')
    end
    posts << Post.new(content: 'no')

    r = ActionAuthorization::Resource.new('test', nil, *posts, behavior: :allow_all)
    assert_equal posts.length, r.get.length
  end

  test 'raises an error when all resources are forbidden' do
    Post.check_perm('test') {|p,r| false}
    posts = []

    5.times do
      posts << Post.new
    end

    r = ActionAuthorization::Resource.new('test', nil, *posts)
    assert_raises(Authorizer::ForbiddenError) do
      r.get
    end
  end
end
