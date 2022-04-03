defmodule Orig.Events.FinancialProfile.FinancialProfileChanged do
  @derive Jason.Encoder

  defstruct ~w(app_id persistence financial_profile)a
end
