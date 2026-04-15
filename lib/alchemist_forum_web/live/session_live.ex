defmodule AlchemistForumWeb.SessionLive do
  use AlchemistForumWeb, :live_view

  alias AlchemistForum.{Accounts, Accounts.User, Accounts.Guardian}

  def mount(_params, session, socket) do
    # Check if user is already authenticated
    maybe_user = get_current_user(session)

    if maybe_user do
      {:ok, socket |> put_flash(:info, "Already logged in") |> push_navigate(to: "/protected")}
    else
      changeset = Accounts.change_user(%User{})
      form = to_form(changeset)

      {:ok, assign(socket, form: form, trigger_submit: false)}
    end
  end

  def render(assigns) do
    ~H"""
    <div>
      <h2>Login Page</h2>

      <.form for={@form} phx-submit="login" phx-trigger-action={@trigger_submit} action="/login" method="post">
        <div>
          <.input field={@form[:email]} label="Email" />
        </div>

        <div>
          <.input field={@form[:password]} type="password" label="Password" />
        </div>

        <div>
          <.button>Submit</.button>
        </div>
      </.form>

      <%= if msg = Phoenix.Flash.get(@flash, :info) do %>
        <div class="alert alert-info">
          <%= msg %>
        </div>
      <% end %>

      <%= if msg = Phoenix.Flash.get(@flash, :error) do %>
        <div class="alert alert-error">
          <%= msg %>
        </div>
      <% end %>
    </div>
    """
  end

  def handle_event("login", %{"user" => %{"email" => email, "password" => password}}, socket) do
    case Accounts.authenticate_user(email, password) do
      {:ok, _user} ->
        # Store user_id in session for Guardian to pick up
        # We need to trigger a form submit to properly handle Guardian authentication
        {:noreply,
         socket
         |> put_flash(:info, "Welcome back!")
         |> assign(trigger_submit: true)}

      {:error, reason} ->
        {:noreply,
         socket
         |> put_flash(:error, to_string(reason))
         |> assign(trigger_submit: false)}
    end
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
