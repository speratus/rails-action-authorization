require 'test_helper'

class PostsControllerTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  test 'correctly authorizes a user' do
    post = Post.first
    user = User.first

    get "/posts/#{post.id}", headers: {"xUser-Id": user.id}
    puts @response.body.class
    assert_equal post.to_json, @response.body
  end

  test 'correctly authorizes many entries' do
    posts = Post.all
    user = User.first

    get posts_url, headers: {"xUser-Id": user.id}
    assert_equal posts.to_json, @response.body
  end
end
