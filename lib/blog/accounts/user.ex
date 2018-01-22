defmodule Blog.Accounts.User do
  use BlogWeb, :model

  schema "users" do
    field :name, :string
    field :username, :string
    field :password, :string, virtual: true
    field :password_hash, :string

    timestamps()
  end

  # Would only be used for things like updating a user where the password is not required.
  @doc false 
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :username])
    |> validate_required([:name, :username])
    |> unique_constraint(:username)
  end

  @doc false
  def registration_changeset(struct, params) do
    struct
    |> changeset(params)
    |> cast(params, [:password])
    |> validate_required([:password])
    |> put_pass_hash()
  end

  defp put_pass_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password_hash, Comeonin.Bcrypt.hashpwsalt(pass))
      _ ->
        changeset
    end
  end
end
