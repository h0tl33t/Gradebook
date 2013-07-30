json.array!(@enrollments) do |enrollment|
  json.extract! enrollment, :student_id, :course_id, :grade
  json.url enrollment_url(enrollment, format: :json)
end
