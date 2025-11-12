defmodule AlchemistForum.Guardian do
  use Guardian, otp_app: :my_app

  def subject_for_token(%{id: id}, _claims) do
    # You can use any value for the subject of your token but
    # it should be useful in retrieving the resource later, see
    # how it is being used on `resource_from_claims/1` function.
    # A unique `id` is a good subject, a non-unique email address
    # is a poor subject.
    sub = to_string(id)
    {:ok, sub}
  end
  def subject_for_token(_, _) do
    {:error, :reason_for_error}
  end

  def resource_from_claims(%{"sub" => id}) do
    {:ok, %{id: id}}
  end

  def resource_from_claims(_claims) do
    {:error, :invalid_claims}
  end

end
