defmodule AlchemistForum.Forum.PostsPin do
  use AlchemistForum.Schema
  import Ecto.Changeset

  alias AlchemistForum.Accounts.User
  alias AlchemistForum.Forum.Post

  @primary_key false
  schema "posts_pins" do
    belongs_to :post, Post, primary_key: true
    belongs_to :pinned_by, User, primary_key: true
    field :role, Ecto.Enum, values: [:moderator, :admin]

    timestamps()
  end

  def changeset(pin, attrs) do
    pin
    |> cast(attrs, [:role, :post_id, :pinned_by_id])
    |> validate_required([:role, :post_id, :pinned_by_id])
    |> assoc_constraint(:post)
    |> assoc_constraint(:pinned_by)
  end
end
