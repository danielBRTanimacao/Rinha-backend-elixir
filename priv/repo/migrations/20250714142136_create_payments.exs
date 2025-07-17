defmodule RinhaBackend.Repo.Migrations.CreatePayments do
  use Ecto.Migration

  def change do
    create table(:payments, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :correlation_id, :uuid, null: false
      add :amount, :decimal, null: false
      add :processor, :string, null: false
      add :requested_at, :utc_datetime_usec, null: false

      timestamps(type: :utc_datetime_usec)
    end
    create unique_index(:payments, [:correlation_id])
  end
end
