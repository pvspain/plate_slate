defmodule PlateSlateWeb.Resolvers.Menu do
  alias PlateSlate.Menu

  def menu_items(_, args, _) do
    {:ok, Menu.list_items(args)}
  end

  def categories(_, args, _) do
    {:ok, Menu.list_categories(args)}
  end

  def items_for_category(category, _, _) do
    query = Ecto.assoc(category, :items)
    {:ok, PlateSlate.Repo.all(query)}
  end

  def search(_, %{matching: term}, _) do
    {:ok, Menu.search(term)}
  end

  def create_item(_, %{input: params}, _) do
    case Menu.create_item(params) do
      {:error, _} -> {:error, "Could not create menu item: #{inspect(params)}"}
      {:ok, _} = success -> success
    end
  end

  def create_category(_, %{input: params}, _) do
    case Menu.create_category(params) do
      {:error, _} -> {:error, "Could not create menu category: #{inspect(params)}"}
      {:ok, _} = success -> success
    end
  end
end
