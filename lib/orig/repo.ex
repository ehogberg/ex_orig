defmodule Orig.Repo do
  use Ecto.Repo,
    otp_app: :orig,
    adapter: Ecto.Adapters.Postgres
end
