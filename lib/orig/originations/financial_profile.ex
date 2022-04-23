import EctoEnum

defenum(Orig.Originations.FinancialProfile.PayPeriod, :pay_period, [
  :monthly,
  :semimonthly,
  :biweekly,
  :weekly,
  :daily,
  :irregular,
  :quarterly,
  :semiannual,
  :annual
])

defmodule Orig.Originations.FinancialProfile do
  use Ecto.Schema
  import Ecto.Changeset

  alias Orig.Originations.OriginationApp
  alias Orig.Originations.FinancialProfile.PayPeriod
  alias Orig.Events.FinancialProfile.{ChangeFinancialProfile, FinancialProfileChanged}

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "financial_profiles" do
    field :periodic_income, :integer
    field :pay_period, PayPeriod
    field :primary_routing_number, :string
    field :primary_account_number, :string

    timestamps(type: :naive_datetime_usec)

    belongs_to :origination_app, OriginationApp,
      foreign_key: :app_id,
      type: Ecto.UUID,
      references: :app_id
  end

  #### Commands
  def dispatch_financial_profile_persistence(attrs, persistence) do
    attrs
    |> ChangeFinancialProfile.new(persistence)
    |> Orig.Events.Application.dispatch(consistency: :strong)
  end

  def apply(
        %__MODULE__{} = fin_prof,
        %FinancialProfileChanged{financial_profile: new_financial_profile}
      ) do
    fin_prof
    |> changeset(new_financial_profile)
    |> apply_changes()
    |> Map.delete(:__meta__)
  end

  def changeset(%__MODULE__{} = fin_prof, attrs) do
    fin_prof
    |> cast(attrs, [
      :app_id,
      :periodic_income,
      :pay_period,
      :primary_routing_number,
      :primary_account_number
    ])
    |> validate_required([
      :app_id,
      :periodic_income,
      :pay_period,
      :primary_routing_number,
      :primary_account_number
    ])
    |> validate_number(:periodic_income, greater_than: 1)
    |> validate_enum(:pay_period)
  end
end
