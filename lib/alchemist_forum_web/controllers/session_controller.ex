defmodule AlchemistForumWeb.SessionController do
  use AlchemistForumWeb, :controller

  alias AlchemistForum.{Accounts, Accounts.Guardian}

  def login(conn, %{"user" => %{"email" => email, "password" => password}}) do
    Accounts.authenticate_user(email, password)
    |> login_reply(conn)
  end

  def signup(conn, %{"user" => user_params}) do
    case Accounts.register_user(user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Account created successfully! Welcome!")
        |> Guardian.Plug.sign_in(user)
        |> redirect(to: "/protected")

      {:error, %Ecto.Changeset{} = _changeset} ->
        conn
        |> put_flash(:error, "There was an error creating your account. Please check the form.")
        |> redirect(to: "/signup")
    end
  end

  def logout(conn, _params) do
    conn
    |> Guardian.Plug.sign_out()
    |> redirect(to: "/login")
  end

  defp login_reply({:ok, user}, conn) do
    conn
    |> put_flash(:info, "Welcome back!")
    |> Guardian.Plug.sign_in(user)
    |> redirect(to: "/protected")
  end

  defp login_reply({:error, reason}, conn) do
    conn
    |> put_flash(:error, to_string(reason))
    |> redirect(to: "/login")
  end
end
