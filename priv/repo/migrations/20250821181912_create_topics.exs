defmodule AlchemistForum.Repo.Migrations.CreateTopics do
  use Ecto.Migration

  def change do
    create table(:topics, primary_key: true) do
      add :title, :string, null: false
      add :slug, :string, null: false
      add :author_id, references(:users, on_delete: :nilify_all)
      add :closed_by, references(:users, on_delete: :nilify_all)

      add :number_of_posts, :integer, null: false, default: 0
      add :its_open, :boolean, null: false, default: true
    end

    create unique_index(:topics, [:slug])
  end
end
