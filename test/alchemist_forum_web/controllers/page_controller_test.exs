defmodule AlchemistForumWeb.PageControllerTest do
  use AlchemistForumWeb.ConnCase

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

    conn =
      conn
      |> put_req_header("authorization", "Bearer #{token}")
      |> get(~p"/protected")

    assert html_response(conn, 200)
  end
end
