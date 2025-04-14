defmodule PlateSlateWeb.Schema.CustomTypes do
  use Absinthe.Schema.Notation

  enum :sort_order do
    value(:asc)
    value(:desc)
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

  scalar :email do
    parse(fn input ->
      with %Absinthe.Blueprint.Input.String{value: value} <- input,
           [username, domain] <- String.split(value, "@") do
        {:ok, {username, domain}}
      else
        _ -> :error
      end
    end)

    serialize(fn {username, domain} ->
      "#{username}@#{domain}"
    end)
  end

  scalar :decimal do
    parse(fn input ->
      with %Absinthe.Blueprint.Input.String{value: value} <- input,
           decimal <- Decimal.new(value) do
        {:ok, decimal}
      else
        _ -> :error
      end
    end)

    serialize(fn decimal -> Decimal.to_string(decimal, :normal) end)
  end
end
