defmodule AlchemistForum.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: true) do
      add :name, :string, null: false
      add :last_name, :string, null: false
      add :nick_name, :string, null: false

      add :email, :string, null: false
      add :password, :string, null: false

      add :strike, :integer, null: false, default: 0
      add :suspend, :boolean, null: false, default: false
      add :status, :string, null: false, default: "offline"
      add :suspended_until, :naive_datetime
      add :type, :string, null: false, default: "normal"
      add :active, :boolean, null: false, default: true
      add :exclude_topic, :boolean, null: false, default: false
      add :bulletin_board, :text

      timestamps()
    end

    create unique_index(:users, [:email])
    create unique_index(:users, [:nick_name])
  end
end
