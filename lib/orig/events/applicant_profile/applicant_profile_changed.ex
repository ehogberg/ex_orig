defmodule Orig.Events.ApplicantProfile.ApplicantProfileChanged do
  @derive Jason.Encoder

  defstruct [:applicant_profile, :app_id, :persistence]
end
