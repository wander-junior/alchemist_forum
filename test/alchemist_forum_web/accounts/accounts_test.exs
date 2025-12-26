defmodule AlchemistForum.AccountsTest do
  use AlchemistForum.DataCase, async: true

  alias AlchemistForum.Accounts
  alias AlchemistForum.Accounts.User
  alias AlchemistForum.Repo

  describe "register_user/1" do
    test "creates a valid user" do
      valid_attrs = %{
        name: "John",
        last_name: "Doe",
        nick_name: "johnny",
        email: "john@example.com",
        password: "supersecret"
      }

      assert {:ok, user} = Accounts.register_user(valid_attrs)
      assert user.name == "John"
      assert user.nick_name == "johnny"
      assert user.email == "john@example.com"
    end

    test "returns error changeset for invalid data" do
      invalid_attrs = %{
        name: "",
        last_name: "",
        nick_name: "",
        email: "not-an-email",
        password: "123"
      }

      assert {:error, %Ecto.Changeset{} = changeset} = Accounts.register_user(invalid_attrs)
      assert errors_on(changeset)[:email]
      assert errors_on(changeset)[:password]
    end
  end
end
