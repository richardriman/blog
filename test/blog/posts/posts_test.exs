defmodule Blog.PostsTest do
  use Blog.ModelCase
  alias Blog.Posts
  alias Blog.Post

  test "list_posts/0 lists all posts" do
    posts = fixture_posts()
    for post <- posts do
      insert_post(post)
    end

    result = Posts.list_posts()
    for post <- posts do
      assert Enum.any?(result, fn p -> p.title == post.title end) == true
    end 
  end
  
  test "list_published_posts/0 lists all published posts" do
    posts = fixture_posts()
    for post <- posts do
      insert_post(post)
    end

    result = Posts.list_published_posts()
    published = Enum.filter(posts, fn p -> p.published == true end) 
    unpublished = Enum.filter(posts, fn p -> p.published == false end) 
                              
    for post <- published do
      assert Enum.any?(result, fn p -> p.title == post.title end) == true
    end 

    for post <- unpublished do
      refute Enum.any?(result, fn p -> p.title == post.title end) == true
    end 
  end
end
