defmodule AlchemistForumWeb.LoginLiveTest do
  use AlchemistForumWeb.ConnCase

  import Phoenix.LiveViewTest

  alias AlchemistForum.Accounts

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

  describe "mount/3" do
    test "mounts successfully for unauthenticated user", %{conn: conn} do
      {:ok, _view, html} = live(conn, "/login")

      assert html =~ "Login Page"
      assert html =~ "Email"
      assert html =~ "Password"
      assert html =~ "Submit"
    end

    test "redirects to /protected if user is already authenticated", %{conn: conn, user: user} do
      {:ok, token, _claims} = AlchemistForum.Accounts.Guardian.encode_and_sign(user)

      conn =
        conn
        |> init_test_session(%{"guardian_default_token" => token})

      assert {:error, {:live_redirect, %{to: "/protected", flash: %{"info" => "Already logged in"}}}} =
               live(conn, "/login")
    end
  end

  describe "handle_event/3 - login" do
    test "successful login with valid credentials", %{conn: conn, user: user} do
      {:ok, view, _html} = live(conn, "/login")

      html =
        view
        |> form("form", user: %{email: user.email, password: "password123"})
        |> render_submit()

      assert html =~ "Welcome back!"
      assert view |> element("form") |> render() =~ "action=\"/login\""
    end

    test "failed login with invalid email", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/login")

      html =
        view
        |> form("form", user: %{email: "wrong@example.com", password: "password123"})
        |> render_submit()

      assert html =~ "invalid_credentials"
    end

    test "failed login with invalid password", %{conn: conn, user: user} do
      {:ok, view, _html} = live(conn, "/login")

      html =
        view
        |> form("form", user: %{email: user.email, password: "wrongpassword"})
        |> render_submit()

      assert html =~ "invalid_credentials"
    end
  end

  describe "render/1" do
    test "displays flash info message", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/login")

      html =
        view
        |> form("form", user: %{email: "test@example.com", password: "password123"})
        |> render_submit()

      assert html =~ "Welcome back!"
      assert html =~ "alert-info"
    end

    test "displays flash error message", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/login")

      html =
        view
        |> form("form", user: %{email: "invalid@example.com", password: "wrong"})
        |> render_submit()

      assert html =~ "invalid_credentials"
      assert html =~ "alert-error"
    end
  end
end
