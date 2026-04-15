defmodule AlchemistForumWeb.SignupLive do
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
      <h2>Sign Up</h2>

      <.form for={@form} phx-submit="signup" phx-trigger-action={@trigger_submit} action="/signup" method="post">
        <div>
          <.input field={@form[:name]} label="First Name" />
        </div>

        <div>
          <.input field={@form[:last_name]} label="Last Name" />
        </div>

        <div>
          <.input field={@form[:nick_name]} label="Nickname" />
        </div>

        <div>
          <.input field={@form[:email]} label="Email" type="email" />
        </div>

        <div>
          <.input field={@form[:password]} type="password" label="Password" />
        </div>

        <div>
          <.button>Sign Up</.button>
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

  def handle_event("signup", %{"user" => _user_params}, socket) do
    # Just trigger form submit to controller which will handle registration and authentication
    {:noreply, assign(socket, trigger_submit: true)}
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
