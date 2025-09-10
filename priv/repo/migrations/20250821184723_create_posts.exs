defmodule AlchemistForum.Repo.Migrations.CreatePosts do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add :topic_id, references(:topics, on_delete: :delete_all), null: false
      add :author_id, references(:users, on_delete: :nilify_all)

      add :message, :string, null: false
      add :number_of_up, :integer, null: false, default: 0
      add :number_of_down, :integer, null: false, default: 0
      add :time_to_edit, :naive_datetime
      add :number_of_messages, :integer, null: false
      add :its_open, :boolean, null: false, default: true

      timestamps()
    end
  end
end
