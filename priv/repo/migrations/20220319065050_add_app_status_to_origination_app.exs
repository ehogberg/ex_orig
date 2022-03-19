defmodule Orig.Repo.Migrations.AddAppStatusToOriginationApp do
  use Ecto.Migration
  alias Orig.Originations.OriginationApp.AppStatus

  def change do
    alter table(:origination_apps) do
      add :app_status, AppStatus.type(), default: "new"
    end
  end
end
