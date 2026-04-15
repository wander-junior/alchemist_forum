defmodule AlchemistForumWeb.PageController do
  use AlchemistForumWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
