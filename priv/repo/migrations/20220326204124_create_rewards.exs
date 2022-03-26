defmodule RewardApp.Repo.Migrations.CreateRewards do
  use Ecto.Migration

  def change do
    create table(:rewards) do
      add :from, :string
      add :to, :string
      add :amount, :integer

      timestamps()
    end
  end
end
