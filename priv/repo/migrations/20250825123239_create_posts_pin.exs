defmodule AlchemistForum.Repo.Migrations.CreatePostPins do
  use Ecto.Migration

  def change do
    create table(:post_pins, primary_key: false) do
      add :post_id, references(:posts, on_delete: :delete_all), null: false
      add :pinned_by_id, references(:users, on_delete: :delete_all), null: false
      add :role, :string

      timestamps()
    end

    create unique_index(:post_pins, [:post_id, :pinned_by_id])
  end
end
