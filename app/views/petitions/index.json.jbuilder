json.array!(@petitions) do |petition|
  json.extract! petition, :id, :title, :text
  json.url petition_url(petition, format: :json)
end
