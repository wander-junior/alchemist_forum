defmodule AlchemistForum.Forum.Post do
  use AlchemistForum.Schema
  import Ecto.Changeset

  alias AlchemistForum.Accounts.User
  alias AlchemistForum.Forum.Topic

  schema "posts" do
    belongs_to :topic, Topic
    belongs_to :author, User
    belongs_to :response_post, __MODULE__

    field :message, :string
    field :number_of_up, :integer, default: 0
    field :number_of_down, :integer, default: 0
    field :time_to_edit, :naive_datetime
    field :number_of_messages, :integer, default: 0
    field :its_open, :boolean, default: true

    timestamps()
  end

  def changeset(posts, attr) do
    posts
    |> cast(attr, [
      :topic_id,
      :author_id,
      :message,
      :response_post
    ])
    |> validate_required([
      :topic_id,
      :author_id,
      :message
    ])
    |> validate_length(:message, min: 3, max: 5000)
    |> assoc_constraint(:topic)
    |> assoc_constraint(:author)
    |> assoc_constraint(:response_post)
  end
end
