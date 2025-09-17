defmodule AlchemistForum.Forum.Topic do
  use AlchemistForum.Schema
  import Ecto.Changeset

  alias AlchemistForum.Accounts.User
  alias AlchemistForum.Forum.Post

  schema "topics" do
    field :title, :string
    field :slug, :string

    field :number_of_posts, :integer, default: 0
    field :its_open, :boolean, default: true

    belongs_to :author, User
    belongs_to :closed_by, User

    has_many :posts, Post

    timestamps()
  end

  def changeset(topic, attrs) do
    topic
    |> cast(attrs, [:title, :slug, :number_of_posts, :its_open, :author_id, :closed_by_id])
    |> validate_required([:title, :slug, :number_of_posts, :its_open, :author_id, :closed_by_id])
    |> validate_length(:title, min: 3, max: 120)
    |> validate_number(:number_of_posts, greater_than: 0)
    |> unique_constraint(:slug)
    |> assoc_constraint(:author)
    |> assoc_constraint(:closed_by)
  end
end
