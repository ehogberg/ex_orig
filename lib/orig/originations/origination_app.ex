defmodule Orig.Originations.OriginationApp do
  use Ecto.Schema
  import Ecto.Changeset

  alias Orig.Events.OriginationApp.{OriginationAppCreated}

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "origination_apps" do
    field :app_id, Ecto.UUID
    field :ssn, :string

    timestamps(type: :naive_datetime_usec)
  end

  @doc false
  def changeset(origination_app, attrs) do
    origination_app
    |> cast(attrs, [:app_id, :ssn])
    |> validate_required([:app_id, :ssn])
  end


  # Event execution and application

  def apply(%__MODULE__{} = orig_app, %OriginationAppCreated{} = create) do
    %__MODULE__{orig_app |
      app_id: create.app_id,
      ssn: create.ssn
    }
  end
end

import EctoEnum
defenum Orig.Originations.OriginationApp.AppStatus, :app_status,
  [:new, :active, :accepted, :rejected, :expired]
