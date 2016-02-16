json.array!(@signatures) do |signature|
  json.extract! signature, :id, :person_name, :person_city, :confirmed_at
end
