defmodule AlchemistForum.Forum.Post do
  use AlchemistForum.Schema
  import Ecto.Changeset

  alias AlchemistForum.Accounts.User
  alias AlchemistForum.Forum.Topic

  @all_fields [
    :topic_id,
    :author_id,
    :message,
    :number_of_up,
    :number_of_down,
    :time_to_edit,
    :number_of_messages,
    :its_open
  ]

  schema "posts" do
    belongs_to :topic, Topic
    belongs_to :author, User

    field :message, :string
    field :number_of_up, :integer, default: 0
    field :number_of_down, :integer, default: 0
    field :time_to_edit, :naive_datetime
    field :number_of_messages, :integer
    field :its_open, :boolean, default: true

    timestamps()
  end

  def changeset(posts, attr) do
    posts
    |> cast(attr, @all_fields)
    |> validate_required(@all_fields)
  end
end
