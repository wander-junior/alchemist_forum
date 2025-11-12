defmodule AlchemistForum.Forum.UserPinTopic do
  use AlchemistForum.Schema
  import Ecto.Changeset

  alias AlchemistForum.Accounts.User
  alias AlchemistForum.Forum.Topic

  @primary_key false
  schema "user_pins_topics" do
    belongs_to :user, User, primary_key: true
    belongs_to :topic, Topic, primary_key: true

    timestamps()
  end

  def changeset(pin, attrs) do
    pin
    |> cast(attrs, [:user_id, :topic_id])
    |> validate_required([:user_id, :topic_id])
    |> assoc_constraint(:user)
    |> assoc_constraint(:topic)
  end
end
