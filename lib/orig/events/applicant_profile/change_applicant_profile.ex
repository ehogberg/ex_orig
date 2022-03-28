defmodule Orig.Events.ApplicantProfile.ChangeApplicantProfile do
  defstruct ~w(applicant_profile app_id persistence)a

  def new(%{app_id: app_id} = attrs, persistence) do
    %__MODULE__{applicant_profile: attrs, app_id: app_id, persistence: persistence}
  end
end
