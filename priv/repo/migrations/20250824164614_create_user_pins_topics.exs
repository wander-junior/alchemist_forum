defmodule AlchemistForum.Repo.Migrations.CreateUserPinsTopics do
  use Ecto.Migration

  def change do
    create table(:user_pin_topics, primary_key: false) do
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :topic_id, references(:topics, on_delete: :delete_all), null: false

      timestamps()
    end

    create unique_index(:user_pin_topics, [:user_id, :topic_id])
  end
end
