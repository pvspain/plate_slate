defmodule PlateSlateWeb.Schema do
  use Absinthe.Schema

  alias PlateSlateWeb.Resolvers

  query do
    field :menu_items, list_of(:menu_item) do
      arg(:matching, :string)
      arg(:order, :sort_order, default_value: :asc)
      # Alternative declaration
      # arg(:order, type: :sort_order, default_value: :asc)
      resolve(&Resolvers.Menu.menu_items/3)
    end
  end

  object :menu_item do
    field :id, :id
    field :name, :string
    field :description, :string
  end

  enum :sort_order do
    value(:asc)
    value(:desc)
  end
end
