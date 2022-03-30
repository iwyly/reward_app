defmodule RewardApp.RewardManager do
  @moduledoc """
  The RewardManager context.
  """

  import Ecto.Query, warn: false
  alias RewardApp.Repo

  alias RewardApp.RewardManager.Reward

  @doc """
  Returns the list of rewards.

  ## Examples

      iex> list_rewards()
      [%Reward{}, ...]

  """
  def list_rewards do
    Repo.all(Reward)
  end

  def list_granted_rewards_by_user(user_email) do
    Repo.all(from r in Reward, where: r.from == ^user_email, select: %{to: r.to, amount: r.amount,  when: r.inserted_at})
  end

  def recent_rewards(rewards_list, how_many) do
    rewards_list
    |> Enum.reverse()
    |> Enum.take(how_many)
  end

  def get_existing_months do
    Repo.all(from r in Reward, select: fragment("date_part('month', ?)", r.inserted_at), distinct: fragment("date_part('month', ?)", r.inserted_at))
    |> Enum.map(fn month ->  trunc(month) end)
  end

  def get_monthly_report_for_users(month) do
    {month, _} = Integer.parse(month)

    Repo.all(from r in Reward, where:  fragment("date_part('month', ?)", r.inserted_at) == ^month, group_by: r.to , select: %{sum: sum(r.amount), member: r.to})
  end


  @doc """
  Gets a single reward.

  Raises `Ecto.NoResultsError` if the Reward does not exist.

  ## Examples

      iex> get_reward!(123)
      %Reward{}

      iex> get_reward!(456)
      ** (Ecto.NoResultsError)

  """
  def get_reward!(id), do: Repo.get!(Reward, id)

  @doc """
  Creates a reward.

  ## Examples

      iex> create_reward(%{field: value})
      {:ok, %Reward{}}

      iex> create_reward(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_reward_record(attrs \\ %{}) do
    %Reward{}
    |> Reward.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a reward.

  ## Examples

      iex> update_reward(reward, %{field: new_value})
      {:ok, %Reward{}}

      iex> update_reward(reward, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_reward(%Reward{} = reward, attrs) do
    reward
    |> Reward.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a reward.

  ## Examples

      iex> delete_reward(reward)
      {:ok, %Reward{}}

      iex> delete_reward(reward)
      {:error, %Ecto.Changeset{}}

  """
  def delete_reward(%Reward{} = reward) do
    Repo.delete(reward)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking reward changes.

  ## Examples

      iex> change_reward(reward)
      %Ecto.Changeset{data: %Reward{}}

  """
  def change_reward(%Reward{} = reward, attrs \\ %{}) do
    Reward.changeset(reward, attrs)
  end
end
