json.array! @daily_workouts do |daily_workout|
  json.extract! daily_workout, :id, :day_number, :daily_challenge_title, :daily_challenge_description, :number_of_exercises
end
