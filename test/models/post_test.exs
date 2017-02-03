defmodule PhoenixBlog.PostTest do
  use PhoenixBlog.ModelCase, async: true
  alias PhoenixBlog.Post

  @valid_attrs %{title: "test post", body: "this is a test post.", published: true}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Post.changeset(%Post{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Post.changeset(%Post{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "changesets with valid attributes generate valid slugs" do
    posts = [
      %{title: "test post", body: "this is a test post.", published: true},
      %{title: "a@test$^post", body: "this is a test post.", published: true},
      %{title: "*()@test%123", body: "this is a test post.", published: true},
      %{title: "123test_post%^&*", body: "this is a test post.", published: true}
    ]
    Enum.each(posts, 
      fn post -> 
        changeset = Post.changeset(%Post{}, post)
        %{slug: slug} = changeset.changes
        assert slug == Slugger.slugify_downcase(post.title)
      end)
  end
end
