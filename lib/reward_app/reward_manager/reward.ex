defmodule RewardApp.RewardManager.Reward do
  use Ecto.Schema
  import Ecto.Changeset

  schema "rewards" do
    field :amount, :integer
    field :from, :string
    field :to, :string

    timestamps()
  end

  @doc false
  def changeset(reward, attrs) do
    reward
    |> cast(attrs, [:from, :to, :amount])
    |> validate_required([:from, :to, :amount])
  end
end
