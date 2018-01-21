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

  @doc """
  Gets a single user.

  ## Examples

      iex> get_user("abc123")
      %User{}

      iex> get_user("bad")
      nil

  """
  def get_user(id) do
    User
    |> Repo.get(id)
  end

  @doc """
  Gets a single user by a given `username`.

  ## Examples

      iex> get_user_by_username("abc123")
      %User{}

      iex> get_user_by_username("bad")
      nil

  """
  def get_user_by_username(username) do
    User
    |> Repo.get_by(username: username)
  end

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
