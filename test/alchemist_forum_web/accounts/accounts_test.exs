defmodule AlchemistForum.AccountsTest do
  use AlchemistForum.DataCase, async: true

  alias AlchemistForum.Accounts
  alias Argon2

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
      assert Argon2.verify_pass("supersecret", user.password_hash)
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

  describe "update_user/2" do
    test "updates user with valid data" do
      valid_attrs = %{
        name: "John",
        last_name: "Doe",
        nick_name: "johnny",
        email: "john@example.com",
        password: "supersecret"
      }

      {:ok, user} = Accounts.register_user(valid_attrs)
      update_attrs = %{name: "Jane", email: "jane@example.com", password: "newsecret"}

      assert {:ok, updated_user} = Accounts.update_user(user, update_attrs)
      assert Argon2.verify_pass("newsecret", updated_user.password_hash)
      assert updated_user.name == "Jane"
      assert updated_user.email == "jane@example.com"
    end
  end
end
