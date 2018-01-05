defmodule Blog.PostsRepoTest do
  use Blog.ModelCase
  alias Blog.Posts
  alias Blog.Post

  @valid_attrs %{title: "test post", body: "this is a test post.", published: true}
  @invalid_attrs %{}

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

  # TODO: dulpicate these for update_post/2
  test "create_post/1 with valid data creates a post" do
    assert {:ok, %Post{} = post} = Posts.create_post(@valid_attrs)
    assert post.title == @valid_attrs.title
  end

  test "create_post/1 with invalid data returns error changeset" do
    assert {:error, %Ecto.Changeset{}} = Posts.create_post(@invalid_attrs)
  end 

  test "create_post/1 with valid data creates posts with valid slugs" do
    posts = [
      %{title: "test post", body: "this is a test post.", published: true},
      %{title: "a@test$^post", body: "this is a test post.", published: true},
      %{title: "*()@test%123", body: "this is a test post.", published: true},
      %{title: "123test_post%^&*", body: "this is a test post.", published: true}
    ]

    for post <- posts do 
      {:ok, %Post{} = new_post} = Posts.create_post(post) 
      assert new_post.slug == Slugger.slugify_downcase(post.title)
    end
  end

  test "create_post/1 converts unique_constraint on slug to error" do
    insert_post(%{title: "a cool post", body: "this is a cool post.", published: true})
    attrs = Map.put(@valid_attrs, :title, "a cool post")
    assert {:error, changeset} = Posts.create_post(attrs) 
    assert {:slug, {"There was a problem generating a unique slug for this post. Please ensure that this title is not already taken.", []}} in changeset.errors
  end

  test "change_post/1 returns a post changeset" do
    post = insert_post(@valid_attrs)
    assert %Ecto.Changeset{} = Posts.change_post(post)
  end 
end
