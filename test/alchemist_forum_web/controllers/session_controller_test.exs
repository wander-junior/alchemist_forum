defmodule AlchemistForumWeb.SessionControllerTest do
  use AlchemistForumWeb.ConnCase

  alias AlchemistForum.Accounts
  alias Phoenix.Flash

  setup do
    # Create a test user for authentication tests
    {:ok, user} =
      Accounts.register_user(%{
        name: "Test",
        last_name: "User",
        nick_name: "testuser",
        email: "test@example.com",
        password: "password123"
      })

    {:ok, user: user}
  end

  describe "POST /login" do
    test "successfully logs in with valid credentials", %{conn: conn, user: user} do
      conn =
        post(conn, ~p"/login", %{
          "user" => %{
            "email" => user.email,
            "password" => "password123"
          }
        })

      assert redirected_to(conn) == "/protected"
      assert Flash.get(conn.assigns.flash, :info) == "Welcome back!"
    end

    test "fails to login with invalid email", %{conn: conn} do
      conn =
        post(conn, ~p"/login", %{
          "user" => %{
            "email" => "wrong@example.com",
            "password" => "password123"
          }
        })

      assert redirected_to(conn) == "/login"
      assert Flash.get(conn.assigns.flash, :error) == "invalid_credentials"
    end

    test "fails to login with invalid password", %{conn: conn, user: user} do
      conn =
        post(conn, ~p"/login", %{
          "user" => %{
            "email" => user.email,
            "password" => "wrongpassword"
          }
        })

      assert redirected_to(conn) == "/login"
      assert Flash.get(conn.assigns.flash, :error) == "invalid_credentials"
    end
  end

  describe "POST /signup" do
    test "successfully creates a new user account", %{conn: conn} do
      conn =
        post(conn, ~p"/signup", %{
          "user" => %{
            "name" => "New",
            "last_name" => "User",
            "nick_name" => "newuser",
            "email" => "newuser@example.com",
            "password" => "password123"
          }
        })

      assert redirected_to(conn) == "/protected"
      assert Flash.get(conn.assigns.flash, :info) == "Account created successfully! Welcome!"
    end

    test "fails to create user with invalid params (missing required fields)", %{conn: conn} do
      conn =
        post(conn, ~p"/signup", %{
          "user" => %{
            "name" => "",
            "email" => ""
          }
        })

      assert redirected_to(conn) == "/signup"
      assert Flash.get(conn.assigns.flash, :error) == "There was an error creating your account. Please check the form."
    end

    test "fails to create user with duplicate email", %{conn: conn, user: user} do
      conn =
        post(conn, ~p"/signup", %{
          "user" => %{
            "name" => "Another",
            "last_name" => "User",
            "nick_name" => "anotheruser",
            "email" => user.email,
            "password" => "password123"
          }
        })

      assert redirected_to(conn) == "/signup"
      assert Flash.get(conn.assigns.flash, :error) == "There was an error creating your account. Please check the form."
    end
  end

  describe "GET /logout" do
    test "successfully logs out authenticated user", %{conn: conn, user: user} do
      # First sign in the user
      {:ok, token, _claims} = AlchemistForum.Accounts.Guardian.encode_and_sign(user)

      conn =
        conn
        |> init_test_session(%{"guardian_default_token" => token})
        |> get(~p"/logout")

      assert redirected_to(conn) == "/login"
    end

    test "logs out without error even when not authenticated", %{conn: conn} do
      conn = get(conn, ~p"/logout")

      assert redirected_to(conn) == "/login"
    end
  end
end
