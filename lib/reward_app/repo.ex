defmodule RewardApp.Repo do
  use Ecto.Repo,
    otp_app: :reward_app,
    adapter: Ecto.Adapters.Postgres
end
