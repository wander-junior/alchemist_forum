defmodule AlchemistForum.Accounts.ErrorHandlerTest do
  use AlchemistForumWeb.ConnCase, async: true

  alias AlchemistForum.Accounts.ErrorHandler

  describe "auth_error/3" do
    test "returns 401 with error type as plain text" do
      conn = build_conn()

      result_conn = ErrorHandler.auth_error(conn, {:invalid_token, :token_expired}, %{})

      assert result_conn.status == 401
      assert get_resp_header(result_conn, "content-type") == ["text/plain; charset=utf-8"]
      assert result_conn.resp_body == "invalid_token"
    end

    test "handles unauthenticated error type" do
      conn = build_conn()

      result_conn = ErrorHandler.auth_error(conn, {:unauthenticated, :no_token}, %{})

      assert result_conn.status == 401
      assert result_conn.resp_body == "unauthenticated"
    end
  end
end
