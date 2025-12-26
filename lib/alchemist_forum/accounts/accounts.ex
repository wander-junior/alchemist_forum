defmodule AlchemistForum.Accounts do
  alias AlchemistForum.Accounts.User
  alias AlchemistForum.Repo

  def get_user!(id), do: Repo.get!(User, id)

  def register_user(attrs) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end
end
