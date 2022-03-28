defmodule Orig.Originations.ApplicantProfile do
  @derive {Jason.Encoder, except: [:__meta__, :origination_app]}

  use Ecto.Schema
  import Ecto.Changeset

  alias Orig.Originations.OriginationApp
  alias Orig.Events.ApplicantProfile.{ChangeApplicantProfile,ApplicantProfileChanged}

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "applicant_profiles" do
    field :address1, :string
    field :address2, :string
    field :city, :string
    field :first_name, :string
    field :last_name, :string
    field :postcode, :string
    field :state, :string

    timestamps()

    belongs_to :origination_app, OriginationApp,
      foreign_key: :app_id, type: Ecto.UUID, references: :app_id
  end

  @doc false
  def changeset(applicant_profile, attrs) do
    applicant_profile
    |> cast(attrs, [:app_id, :first_name, :last_name, :address1, :address2, :city, :state, :postcode])
    |> validate_required([:app_id, :first_name, :last_name, :address1, :city, :state, :postcode])
  end


  def validate_app_profile(app_profile,attrs) do
    app_profile
    |> changeset(attrs)
    |> apply_action(:validate)
  end

  # CQRS event handling

  def dispatch_applicant_profile_persistence(attrs, persistence) do
    attrs
    |> ChangeApplicantProfile.new(persistence)
    |> Orig.Events.Application.dispatch(consistency: :strong)
  end

  def apply(%__MODULE__{} = app_prof,
   %ApplicantProfileChanged{applicant_profile: changed_prof}) do
    app_prof
    |> changeset(changed_prof)
    |> apply_changes()
    |> Map.delete(:__meta__)
  end

end
