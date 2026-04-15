defmodule AlchemistForumWeb.ProtectedLiveTest do
  use AlchemistForumWeb.ConnCase

  import Phoenix.LiveViewTest
  import Phoenix.ConnTest

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
    test "mounts successfully for authenticated user", %{conn: conn, user: user} do
      {:ok, token, _claims} = AlchemistForum.Accounts.Guardian.encode_and_sign(user)

      conn =
        conn
        |> init_test_session(%{"guardian_default_token" => token})

      {:ok, _view, html} = live(conn, "/protected")

      assert html =~ "Protected Page"
      assert html =~ "You can only see this page if you are logged in"
      assert html =~ "You&#39;re logged in as #{user.name}"
    end

    test "assigns current_user when authenticated", %{conn: conn, user: user} do
      {:ok, token, _claims} = AlchemistForum.Accounts.Guardian.encode_and_sign(user)

      conn =
        conn
        |> init_test_session(%{"guardian_default_token" => token})

      {:ok, view, _html} = live(conn, "/protected")

      # Verify current_user is assigned by checking it's displayed in the render
      assert render(view) =~ user.name
    end

    test "returns 401 when user is not authenticated (caught by Guardian pipeline)", %{conn: conn} do
      # The Guardian.Plug.EnsureAuthenticated pipeline catches this before mount
      conn = get(conn, "/protected")

      # Should return 401 unauthorized
      assert conn.status == 401
      assert conn.resp_body == "unauthenticated"
    end

    test "returns 401 when token is invalid (caught by Guardian pipeline)", %{conn: conn} do
      conn =
        conn
        |> init_test_session(%{"guardian_default_token" => "invalid_token"})

      conn = get(conn, "/protected")

      # Should return 401 unauthorized
      assert conn.status == 401
    end

    test "returns 401 when token is nil (caught by Guardian pipeline)", %{conn: conn} do
      conn =
        conn
        |> init_test_session(%{"guardian_default_token" => nil})

      conn = get(conn, "/protected")

      # Should return 401 unauthorized
      assert conn.status == 401
    end

    test "mount/3 redirects to login when get_current_user returns nil (direct test)" do
      # Test the mount function directly to cover the redirect logic
      socket = %Phoenix.LiveView.Socket{
        endpoint: AlchemistForumWeb.Endpoint,
        router: AlchemistForumWeb.Router,
        assigns: %{__changed__: %{}, flash: %{}}
      }

      # Call mount directly with empty session to trigger the nil user path
      assert {:ok, socket_result} = AlchemistForumWeb.ProtectedLive.mount(%{}, %{}, socket)

      # Verify redirect was set - the redirect function returns a tuple stored in the socket
      assert socket_result.redirected == {:redirect, %{status: 302, to: "/login"}}
    end
  end

  describe "render/1" do
    test "displays user name when authenticated", %{conn: conn, user: user} do
      {:ok, token, _claims} = AlchemistForum.Accounts.Guardian.encode_and_sign(user)

      conn =
        conn
        |> init_test_session(%{"guardian_default_token" => token})

      {:ok, _view, html} = live(conn, "/protected")

      assert html =~ user.name
      assert html =~ "Protected Page"
    end

    test "displays protected content", %{conn: conn, user: user} do
      {:ok, token, _claims} = AlchemistForum.Accounts.Guardian.encode_and_sign(user)

      conn =
        conn
        |> init_test_session(%{"guardian_default_token" => token})

      {:ok, _view, html} = live(conn, "/protected")

      assert html =~ "You can only see this page if you are logged in"
    end
  end
end
