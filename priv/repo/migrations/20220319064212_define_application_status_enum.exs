defmodule Orig.Repo.Migrations.AddApplicationType do
  use Ecto.Migration
  alias Orig.Originations.OriginationApp.AppStatus

  def change do
    AppStatus.create_type
  end
end
