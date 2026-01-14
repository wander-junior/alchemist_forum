defmodule AlchemistForumWeb.PageController do
  use AlchemistForumWeb, :controller
  alias AlchemistForum.Accounts.Guardian

  def protected(conn, _params) do
    user = Guardian.Plug.current_resource(conn)

    render(conn, :protected, current_user: user)
  end

  def home(conn, _params) do
    render(conn, :home)
  end
end
