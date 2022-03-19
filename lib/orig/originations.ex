defmodule Orig.Originations do
  @moduledoc """
  The Originations context.
  """

  import Ecto.Query, warn: false
    alias Orig.Repo

  alias Orig.Originations.OriginationApp

  alias Orig.Events.Application;
  alias Orig.Events.OriginationApp.{CreateOriginationApp, RejectOriginationApp}

  @doc """
  Returns the list of origination_apps.

  ## Examples

      iex> list_origination_apps()
      [%OriginationApp{}, ...]

  """
  def list_origination_apps do
    Repo.all(OriginationApp)
  end

  @doc """
  Gets a single origination_app.

  Raises `Ecto.NoResultsError` if the Origination app does not exist.

  ## Examples

      iex> get_origination_app!(123)
      %OriginationApp{}

      iex> get_origination_app!(456)
      ** (Ecto.NoResultsError)

  """
  def get_origination_app!(id), do: Repo.get!(OriginationApp, id)

  @doc """
  Creates a origination_app.
  """

  def create_origination_app(attrs \\ %{}) do
    create = struct(CreateOriginationApp,
      Map.put(attrs, :app_id, Ecto.UUID.generate()))
    Application.dispatch(create, consistency: :strong)
  end

  def reject_origination_app(app_id) do
    reject = %RejectOriginationApp{app_id: app_id}
    Application.dispatch(reject)
  end
  @doc """
  Updates a origination_app.

  ## Examples

      iex> update_origination_app(origination_app, %{field: new_value})
      {:ok, %OriginationApp{}}

      iex> update_origination_app(origination_app, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_origination_app(%OriginationApp{} = origination_app, attrs) do
    origination_app
    |> OriginationApp.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a origination_app.

  ## Examples

      iex> delete_origination_app(origination_app)
      {:ok, %OriginationApp{}}

      iex> delete_origination_app(origination_app)
      {:error, %Ecto.Changeset{}}

  """
  def delete_origination_app(%OriginationApp{} = origination_app) do
    Repo.delete(origination_app)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking origination_app changes.

  ## Examples

      iex> change_origination_app(origination_app)
      %Ecto.Changeset{data: %OriginationApp{}}

  """
  def change_origination_app(%OriginationApp{} = origination_app, attrs \\ %{}) do
    OriginationApp.changeset(origination_app, attrs)
  end
end
