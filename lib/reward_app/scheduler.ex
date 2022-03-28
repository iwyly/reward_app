defmodule RewardApp.Scheduler do
  use Quantum, otp_app: :reward_app
  alias RewardApp.Accounts

  def reset_users_reward_pool() do
    Accounts.get_all_members()
    |> Enum.each(&Accounts.update_user_reward_pool(&1, %{reward_pool: 50}))
  end
end
