defmodule PlateSlateWeb.Schema do
  use Absinthe.Schema

  alias PlateSlateWeb.Resolvers

  query do
    field :menu_items, list_of(:menu_item) do
      arg(:filter, :menu_item_filter)
      arg(:order, :sort_order, default_value: :asc)
      # Alternative declaration
      # arg(:order, type: :sort_order, default_value: :asc)
      resolve(&Resolvers.Menu.menu_items/3)
    end

    field :categories, list_of(:category) do
      arg(:matching, :string)
      arg(:order, :sort_order, default_value: :asc)
      resolve(&Resolvers.Menu.categories/3)
    end
  end

  object :menu_item do
    field :id, :id
    field :name, :string
    field :description, :string
    field :added_on, :date
  end

  enum :sort_order do
    value(:asc)
    value(:desc)
  end

  @desc "Filtering options for the menu item list"
  input_object :menu_item_filter do
    @desc "Matching a name"
    field :name, :string

    @desc "Matching a category name"
    field :category, :string

    @desc "Matching a tag"
    field :tag, :string

    @desc "Priced above a value"
    field :priced_above, :float

    @desc "Priced below a value"
    field :priced_below, :float

    @desc "Added to the menu before this date"
    field :added_before, :date

    @desc "Added to the menu after this date"
    field :added_after, :date
  end

  scalar :date do
    parse(fn input ->
      with %Absinthe.Blueprint.Input.String{value: value} <- input,
           {:ok, date} <- Date.from_iso8601(value) do
        {:ok, date}
      else
        _ -> :error
      end
    end)

    serialize(fn date ->
      Date.to_iso8601(date)
    end)
  end

  object :category do
    field :name, :string
    field :description, :string
  end
end
