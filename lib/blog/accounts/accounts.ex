defmodule Blog.Accounts do
  @moduledoc """
  This is the context which handles all accounts functionality.
  """

  import Ecto.Query, warn: false
  alias Blog.Repo
  alias Blog.User

  @doc """
  Gets a list of all users.

  ## Examples
  
      iex> list_users()
      [%User{}, ...] 

  """
  def list_users() do
    Repo.all(User)
  end

  #@doc """
  #Gets a single post.

  #Raises `Ecto.NoResultsError` if the post does not exist.

  ### Examples

      #iex> get_post_by_slug("abc123")
      #%Post{}

      #iex> get_post_by_slug("bad")
      #** (Ecto.NoResultsError)

  #"""
  #def get_post_by_slug!(slug) do
    #Post
    #|> Repo.get_by!(slug: slug)
  #end

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %Post{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.registration_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples
  
      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(%User{} = user) do
    User.registration_changeset(user, %{})
  end
end
