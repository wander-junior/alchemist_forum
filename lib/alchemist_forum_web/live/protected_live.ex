defmodule AlchemistForumWeb.ProtectedLive do
  use AlchemistForumWeb, :live_view

  alias AlchemistForum.Accounts.Guardian

  def mount(_params, session, socket) do
    case get_current_user(session) do
      nil ->
        {:ok,
         socket
         |> put_flash(:error, "You must be logged in to access this page")
         |> redirect(to: "/login")}

      user ->
        {:ok, assign(socket, current_user: user)}
    end
  end

  def render(assigns) do
    ~H"""
    <div>
      <h2>Protected Page</h2>
      <p>You can only see this page if you are logged in</p>
      <p>You're logged in as <%= @current_user.name %></p>
    </div>
    """
  end

  defp get_current_user(session) do
    with token when is_binary(token) <- session["guardian_default_token"],
         {:ok, claims} <- Guardian.decode_and_verify(token),
         {:ok, user} <- Guardian.resource_from_claims(claims) do
      user
    else
      _ -> nil
    end
  end
end
