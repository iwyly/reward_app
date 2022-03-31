defmodule RewardApp.RewardManagerFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `RewardApp.RewardManager` context.
  """

  @doc """
  Generate a reward.
  """
  def reward_fixture(attrs \\ %{}) do
    {:ok, reward} =
      attrs
      |> Enum.into(%{
        amount: 42,
        from: "some from",
        to: "some to"
      })
      |> RewardApp.RewardManager.create_reward_record()

    reward
  end
end
