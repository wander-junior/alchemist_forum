defmodule AlchemistForum.Accounts.Pipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :alchemist_forum,
    module: AlchemistForum.Accounts.Guardian,
    error_handler: AlchemistForum.Accounts.ErrorHandler

  plug Guardian.Plug.VerifySession, claims: %{"typ" => "access"}
  plug Guardian.Plug.VerifyHeader, claims: %{"typ" => "access"}
  plug Guardian.Plug.LoadResource, allow_blank: true
end
