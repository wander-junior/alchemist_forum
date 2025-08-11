defmodule AlchemistForum.Repo do
  use Ecto.Repo,
    otp_app: :alchemist_forum,
    adapter: Ecto.Adapters.Postgres
end
