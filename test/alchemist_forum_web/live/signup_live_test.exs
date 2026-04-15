defmodule AlchemistForumWeb.SignupLiveTest do
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
      {:ok, _view, html} = live(conn, "/signup")

      assert html =~ "Sign Up"
      assert html =~ "First Name"
      assert html =~ "Last Name"
      assert html =~ "Nickname"
      assert html =~ "Email"
      assert html =~ "Password"
    end

    test "redirects to /protected if user is already authenticated", %{conn: conn, user: user} do
      {:ok, token, _claims} = AlchemistForum.Accounts.Guardian.encode_and_sign(user)

      conn =
        conn
        |> init_test_session(%{"guardian_default_token" => token})

      assert {:error, {:live_redirect, %{to: "/protected", flash: %{"info" => "Already logged in"}}}} =
               live(conn, "/signup")
    end
  end

  describe "handle_event/3 - signup" do
    test "sets trigger_submit to true on signup event", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/signup")

      # Verify trigger_submit starts as false (no phx-trigger-action attribute)
      initial_html = render(view)
      refute initial_html =~ "phx-trigger-action"

      # Submit the form
      view
      |> form("form", user: %{
        name: "New",
        last_name: "User",
        nick_name: "newuser",
        email: "newuser@example.com",
        password: "password123"
      })
      |> render_submit()

      # After submit, verify trigger_submit was set to true
      updated_html = render(view)
      assert updated_html =~ "phx-trigger-action"
    end

    test "handles signup with empty params", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/signup")

      # Submit with empty params
      view
      |> form("form", user: %{})
      |> render_submit()

      # Should still trigger the submit
      updated_html = render(view)
      assert updated_html =~ "phx-trigger-action"
    end
  end

  describe "render/1" do
    test "displays all form fields", %{conn: conn} do
      {:ok, _view, html} = live(conn, "/signup")

      assert html =~ "name=\"user[name]\""
      assert html =~ "name=\"user[last_name]\""
      assert html =~ "name=\"user[nick_name]\""
      assert html =~ "name=\"user[email]\""
      assert html =~ "name=\"user[password]\""
      assert html =~ "type=\"email\""
      assert html =~ "type=\"password\""
    end

    test "displays submit button", %{conn: conn} do
      {:ok, _view, html} = live(conn, "/signup")

      assert html =~ "Sign Up"
      assert html =~ "<button"
    end

    test "form has correct action and method", %{conn: conn} do
      {:ok, _view, html} = live(conn, "/signup")

      assert html =~ "action=\"/signup\""
      assert html =~ "method=\"post\""
    end

    test "renders without flash messages initially", %{conn: conn} do
      {:ok, _view, html} = live(conn, "/signup")

      # Flash messages are not displayed when not set
      refute html =~ "alert-info"
      refute html =~ "alert-error"
    end
  end
end
