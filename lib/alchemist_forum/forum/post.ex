defmodule AlchemistForum.Forum.Post do
  use AlchemistForum.Schema

  alias AlchemistForum.Accounts.User
  alias AlchemistForum.Forum.Topic

  schema "posts" do
    belongs_to :topic_id, Topic
    belongs_to :author_id, User

    field :message, :string
    field :number_of_up, :integer, default: 0
    field :number_of_down, :integer, default: 0
    field :time_to_edit, :naive_datetime
    field :number_of_messages, :integer
    field :its_open, :boolean, default: true

    timestamps()
  end
end
