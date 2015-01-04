json.array!(@ideas) do |idea|
  json.extract! idea, :id, :name, :description, :profit_rating, :skill_rating, :passion_rating
  json.url idea_url(idea, format: :json)
end
