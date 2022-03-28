defmodule Orig.OriginationsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Orig.Originations` context.
  """

  @doc """
  Generate a origination_app.
  """
  def origination_app_fixture(attrs \\ %{}) do
    {:ok, origination_app} =
      attrs
      |> Enum.into(%{
        app_id: "7488a646-e31f-11e4-aace-600308960662",
        ssn: "111223333"
      })
      |> Orig.Originations.create_origination_app()

    origination_app
  end
end
