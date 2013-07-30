json.array!(@courses) do |course|
  json.extract! course, :name, :long_title, :description, :credit_hours
  json.url course_url(course, format: :json)
end
