defmodule AlchemistForum.Forum.Topic do
  use AlchemistForum.Schema

  alias AlchemistForum.Accounts.User

  schema "topics" do
    field :title, :string
    field :slug, :string

    field :number_of_posts, :integer, default: 0
    field :its_open, :boolean, default: true

    belongs_to :author_id, User
    belongs_to :closed_by, User

    timestamps()
  end
end
