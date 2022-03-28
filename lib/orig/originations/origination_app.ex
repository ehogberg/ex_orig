import EctoEnum

defenum(Orig.Originations.OriginationApp.AppStatus, :app_status, [
  :new,
  :active,
  :accepted,
  :rejected,
  :expired
])

defmodule Orig.Originations.OriginationApp do
  @derive {Jason.Encoder, except: [:__meta__, :applicant_profile]}

  use Ecto.Schema
  import Ecto.Changeset

  alias Orig.Events.OriginationApp.{
    CreateOriginationApp,
    OriginationAppCreated,
    OriginationAppRejected
  }

  alias Orig.Originations.OriginationApp.AppStatus
  alias Orig.Originations.ApplicantProfile

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "origination_apps" do
    field :app_id, Ecto.UUID
    field :ssn, :string
    field :app_status, AppStatus
    timestamps(type: :naive_datetime_usec)

    has_one :applicant_profile, ApplicantProfile, references: :app_id, foreign_key: :app_id
  end

  @doc false
  def changeset(origination_app, attrs) do
    origination_app
    |> cast(attrs, [:app_id, :ssn])
    |> validate_required([:app_id, :ssn])
  end

  def reject_origination_app_changeset(origination_app) do
    change(origination_app, %{app_status: "rejected"})
  end

  #### Event execution and application

  def dispatch_create_origination_app(attrs) do
    attrs
    |> CreateOriginationApp.new()
    |> Orig.Events.Application.dispatch(consistency: :strong)
  end

  def validate_origination_app(%__MODULE__{} = orig_app, attrs) do
    orig_app
    |> changeset(attrs)
    |> apply_action(:validate)
  end

  def apply(%__MODULE__{} = orig_app, %OriginationAppCreated{} = create) do
    %__MODULE__{orig_app | app_id: create.app_id, ssn: create.ssn}
  end

  def apply(%__MODULE__{} = orig_app, %OriginationAppRejected{}) do
    %__MODULE__{orig_app | app_status: "rejected"}
  end
end
