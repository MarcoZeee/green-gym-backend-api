json.extract! @daily_workout_tracker, :id, :dwt_check_in, :dwt_daily_challenge, :program_tracker_id, :daily_workout_id

json.extract! @daily_workout_tracker.program_tracker, :program_id, :user_id
json.extract! @daily_workout_tracker.daily_workout, :daily_challenge_title, :day_number, :daily_challenge_description, :number_of_exercises
