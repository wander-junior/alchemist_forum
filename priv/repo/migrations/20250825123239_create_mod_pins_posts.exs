defmodule AlchemistForum.Repo.Migrations.CreateModPinsPosts do
  use Ecto.Migration

  def change do
    create table(:mod_pins_posts, primary_key: false) do
      add :post_id, references(:posts, on_delete: :delete_all), null: false
      add :pinned_by_id, references(:users, on_delete: :delete_all), null: false

      timestamps()
    end

    create unique_index(:mod_pins_posts, [:post_id, :pinned_by_id])
  end
end
