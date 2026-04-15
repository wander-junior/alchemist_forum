defmodule AlchemistForum.Accounts.GuardianTest do
  use AlchemistForum.DataCase, async: true

  alias AlchemistForum.Accounts
  alias AlchemistForum.Accounts.Guardian

  describe "subject_for_token/2" do
    test "returns the user id as a string" do
      {:ok, user} =
        Accounts.register_user(%{
          name: "John",
          last_name: "Doe",
          nick_name: "johndoe",
          email: "john@example.com",
          password: "password123"
        })

      assert {:ok, user_id} = Guardian.subject_for_token(user, %{})
      assert user_id == to_string(user.id)
    end
  end

  describe "resource_from_claims/1" do
    test "returns the user when given valid claims" do
      {:ok, user} =
        Accounts.register_user(%{
          name: "Jane",
          last_name: "Smith",
          nick_name: "janesmith",
          email: "jane@example.com",
          password: "password123"
        })

      claims = %{"sub" => to_string(user.id)}

      assert {:ok, retrieved_user} = Guardian.resource_from_claims(claims)
      assert retrieved_user.id == user.id
      assert retrieved_user.email == user.email
    end

    test "returns error when user is not found" do
      # Use a valid UUID format that doesn't exist in the database
      fake_uuid = "00000000-0000-0000-0000-000000000000"
      claims = %{"sub" => fake_uuid}

      assert {:error, :resource_not_found} = Guardian.resource_from_claims(claims)
    end
  end
end
