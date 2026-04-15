defmodule AlchemistForumWeb.PageControllerTest do
  use AlchemistForumWeb.ConnCase

  import Phoenix.LiveViewTest

  alias AlchemistForum.Accounts

  test "GET /", %{conn: conn} do
    conn = get(conn, ~p"/")
    assert html_response(conn, 200) =~ "Peace of mind from prototype to production"
  end

  test "GET /protected with authenticated user", %{conn: conn} do
    {:ok, user} =
      Accounts.register_user(%{
        name: "Test",
        last_name: "User",
        nick_name: "testuser",
        email: "test@example.com",
        password: "password123"
      })

    {:ok, token, _claims} = AlchemistForum.Accounts.Guardian.encode_and_sign(user)

    conn = init_test_session(conn, %{"guardian_default_token" => token})

    {:ok, _view, html} = live(conn, "/protected")

    assert html =~ "Protected Page"
    assert html =~ "You can only see this page if you are logged in"
    assert html =~ "logged in as #{user.name}"
  end
end
