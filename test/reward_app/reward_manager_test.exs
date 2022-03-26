defmodule RewardApp.RewardManagerTest do
  use RewardApp.DataCase

  alias RewardApp.RewardManager

  describe "rewards" do
    alias RewardApp.RewardManager.Reward

    import RewardApp.RewardManagerFixtures

    @invalid_attrs %{amount: nil, from: nil, to: nil}

    test "list_rewards/0 returns all rewards" do
      reward = reward_fixture()
      assert RewardManager.list_rewards() == [reward]
    end

    test "get_reward!/1 returns the reward with given id" do
      reward = reward_fixture()
      assert RewardManager.get_reward!(reward.id) == reward
    end

    test "create_reward/1 with valid data creates a reward" do
      valid_attrs = %{amount: 42, from: "some from", to: "some to"}

      assert {:ok, %Reward{} = reward} = RewardManager.create_reward(valid_attrs)
      assert reward.amount == 42
      assert reward.from == "some from"
      assert reward.to == "some to"
    end

    test "create_reward/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = RewardManager.create_reward(@invalid_attrs)
    end

    test "update_reward/2 with valid data updates the reward" do
      reward = reward_fixture()
      update_attrs = %{amount: 43, from: "some updated from", to: "some updated to"}

      assert {:ok, %Reward{} = reward} = RewardManager.update_reward(reward, update_attrs)
      assert reward.amount == 43
      assert reward.from == "some updated from"
      assert reward.to == "some updated to"
    end

    test "update_reward/2 with invalid data returns error changeset" do
      reward = reward_fixture()
      assert {:error, %Ecto.Changeset{}} = RewardManager.update_reward(reward, @invalid_attrs)
      assert reward == RewardManager.get_reward!(reward.id)
    end

    test "delete_reward/1 deletes the reward" do
      reward = reward_fixture()
      assert {:ok, %Reward{}} = RewardManager.delete_reward(reward)
      assert_raise Ecto.NoResultsError, fn -> RewardManager.get_reward!(reward.id) end
    end

    test "change_reward/1 returns a reward changeset" do
      reward = reward_fixture()
      assert %Ecto.Changeset{} = RewardManager.change_reward(reward)
    end
  end
end
