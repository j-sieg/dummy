def log(msg)
  puts "[ db/seeds.rb ] #{msg}"
end

unless Rails.env.development?
  log "Skipping seeds. This is only supposed to run in the `development` environment"
  exit 0
end

user_1 = User.create!(email: "jpeck@example.com", password: "it's m3?", confirmed_at: Time.current)

if user_1.persisted?
  log "Created default User"
  log "Email: jpeck@example.com"
  log "Password: it's m3?"
end

user_2 = User.create!(email: "peck@example.com", password: "it's m3?", confirmed_at: Time.current)

if user_2.persisted?
  log "Created default User"
  log "Email: #{user_2.email}"
  log "Password: it's m3?"
end

conversation = Conversation.create!(name: "General")
conversation.participants << [user_1, user_2]

log "Created default #{conversation.name} conversation"

log "Done!"
