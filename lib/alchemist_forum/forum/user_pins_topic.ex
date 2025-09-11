defmodule AlchemistForum.Forum.UserPinTopic do
  use AlchemistForum.Schema

  alias AlchemistForum.Accounts.User
  alias AlchemistForum.Forum.Topic

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "user_pins_topics" do
    belongs_to :user_id, User, primary_key: true
    belongs_to :topic_id, Topic, primary_key: true

    timestamps()
  end
end
