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

    test "returns error changeset for invalid data" do
      valid_attrs = %{
        name: "John",
        last_name: "Doe",
        nick_name: "johnny",
        email: "john@example.com",
        password: "supersecret"
      }

      {:ok, user} = Accounts.register_user(valid_attrs)
      invalid_attrs = %{email: "not-an-email", password: "12"}

      assert {:error, %Ecto.Changeset{} = changeset} = Accounts.update_user(user, invalid_attrs)
      assert errors_on(changeset)[:email]
      assert errors_on(changeset)[:password]
    end
  end

  describe "get_user!/1" do
    test "returns user when given valid id" do
      {:ok, user} =
        Accounts.register_user(%{
          name: "Jane",
          last_name: "Smith",
          nick_name: "janesmith",
          email: "jane@example.com",
          password: "password123"
        })

      retrieved_user = Accounts.get_user!(user.id)
      assert retrieved_user.id == user.id
      assert retrieved_user.email == user.email
    end

    test "raises when user is not found" do
      fake_uuid = "00000000-0000-0000-0000-000000000000"

      assert_raise Ecto.NoResultsError, fn ->
        Accounts.get_user!(fake_uuid)
      end
    end
  end

  describe "delete_user/1" do
    test "deletes the user" do
      {:ok, user} =
        Accounts.register_user(%{
          name: "Bob",
          last_name: "Johnson",
          nick_name: "bobby",
          email: "bob@example.com",
          password: "password123"
        })

      assert {:ok, deleted_user} = Accounts.delete_user(user)
      assert deleted_user.id == user.id

      assert_raise Ecto.NoResultsError, fn ->
        Accounts.get_user!(user.id)
      end
    end
  end

  describe "change_user/1" do
    test "returns a changeset for user" do
      {:ok, user} =
        Accounts.register_user(%{
          name: "Alice",
          last_name: "Wonder",
          nick_name: "alicew",
          email: "alice@example.com",
          password: "password123"
        })

      changeset = Accounts.change_user(user)
      assert %Ecto.Changeset{} = changeset
      assert changeset.data == user
    end
  end

  describe "authenticate_user/2" do
    setup do
      {:ok, user} =
        Accounts.register_user(%{
          name: "Test",
          last_name: "User",
          nick_name: "testuser",
          email: "test@example.com",
          password: "password123"
        })

      %{user: user}
    end

    test "returns user with valid credentials", %{user: user} do
      assert {:ok, authenticated_user} = Accounts.authenticate_user("test@example.com", "password123")
      assert authenticated_user.id == user.id
      assert authenticated_user.email == user.email
    end

    test "returns error with invalid password", %{user: _user} do
      assert {:error, :invalid_credentials} = Accounts.authenticate_user("test@example.com", "wrongpassword")
    end

    test "returns error with non-existent email" do
      assert {:error, :invalid_credentials} = Accounts.authenticate_user("nonexistent@example.com", "password123")
    end
  end
end
