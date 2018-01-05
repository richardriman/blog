defmodule PostRepoTest do
  use Blog.ModelCase
  alias Blog.Post

  @valid_attrs %{title: "test post", body: "this is a test post.", published: true}

  test "converts unique_constraint on slug to error" do
    insert_post(%{title: "a cool post", body: "this is a cool post.", published: true})
    attrs = Map.put(@valid_attrs, :title, "a cool post")
    changeset = Post.changeset(%Post{}, attrs)
    assert {:error, changeset} = Repo.insert(changeset)
    assert {:slug, {"There was a problem generating a unique slug for this post. Please ensure that this title is not already taken.", []}} in changeset.errors
  end
end