json.extract! @program_tracker, :id, :program_id, :user_id

json.extract! @program_tracker.program, :program_title, :program_description
json.extract! @program_tracker.user, :email, :admin

# json.user @program_tracker.user do |user|
#   json.extract! user, :email
# end
