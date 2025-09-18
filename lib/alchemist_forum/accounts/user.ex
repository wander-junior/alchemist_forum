defmodule AlchemistForum.Accounts.User do
  use AlchemistForum.Schema
  import Ecto.Changeset

  schema "users" do
    field :name, :string
    field :last_name, :string
    field :nick_name, :string

    field :email, :string
    field :password, :string

    field :strike, :integer, default: 0
    field :suspend, :boolean, default: false

    field :status, Ecto.Enum,
      values: [:online, :offline, :suspended, :expelled],
      default: :offline

    field :suspended_until, :naive_datetime
    field :type, Ecto.Enum, values: [:normal, :moderator, :admin], default: :normal
    field :active, :boolean, default: true
    field :exclude_topic, :boolean, default: false
    field :bulletin_board, :string

    timestamps(inserted_at: :registered_at)
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [
      :name,
      :last_name,
      :nick_name,
      :email,
      :password,
      :strike,
      :suspend,
      :status,
      :suspended_until,
      :type,
      :active,
      :exclude_topic,
      :bulletin_board
    ])
    |> validate_required([
      :name,
      :last_name,
      :nick_name,
      :email,
      :password
    ])
    |> validate_length(:name, min: 3, max: 50)
    |> validate_length(:last_name, min: 3, max: 50)
    |> validate_length(:nick_name, min: 3, max: 30)
    |> validate_length(:password, min: 6, max: 100)
    |> validate_format(:email, ~r/^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/)
    |> unique_constraint(:email)
    |> unique_constraint(:nick_name)
  end
end
