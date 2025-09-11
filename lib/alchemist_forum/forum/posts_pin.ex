defmodule AlchemistForum.Forum.PostsPin do
  use AlchemistForum.Schema

  alias AlchemistForum.Accounts.User
  alias AlchemistForum.Forum.Post

  schema "posts_pins" do
      belongs_to :post_id, Post, primary_key: true
      belongs_to :pinned_by_id, User, primary_key: true
      field :role, :string

    timestamps()
  end
end
