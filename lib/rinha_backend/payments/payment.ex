defmodule RinhaBackend.Payments.Payment do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "payments" do
    field :correlation_id, Ecto.UUID
    field :amount, :decimal
    field :processor, :string
    field :requested_at, :utc_datetime_usec

    timestamps(type: :utc_datetime_usec)
  end

  def changeset(payment, attrs) do
    payment
    |> cast(attrs, [:correlation_id, :amount, :processor, :requested_at])
    |> validate_required([:correlation_id, :amount, :processor, :requested_at])
    |> unique_constraint(:correlation_id)
  end

end
