defmodule AlchemistForum.Accounts.User do
  use AlchemistForum.Schema

  schema "users" do
    field :name, :string
    field :last_name, :string
    field :nick_name, :string

    field :email, :string
    field :password, :string

    field :strike, :integer, default: 0
    field :suspend, :boolean, default: false
    field :status, Ecto.Enum, values: [:online, :offline, :suspended, :expelled], default: :offline
    field :suspended_until, :naive_datetime
    field :type, Ecto.Enum, values: [:normal, :moderator, :admin], default: :normal
    field :active, :boolean, default: true
    field :exclude_topic, :boolean, default: false
    field :bulletin_board, :string

    timestamps(inserted_at: :registered_at)
  end
end
