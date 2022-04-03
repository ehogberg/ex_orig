defmodule Orig.Events.FinancialProfile.ChangeFinancialProfile do
  defstruct ~w(financial_profile app_id persistence)a

  def new(%{app_id: app_id} = attrs, persistence) do
    %__MODULE__{app_id: app_id, financial_profile: attrs, persistence: persistence}
  end
end
