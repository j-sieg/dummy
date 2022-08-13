def log(msg)
  puts "[ db/seeds.rb ] #{msg}"
end

unless Rails.env.development?
  log "Skipping seeds. This is only supposed to run in the `development` environment"
  exit 0
end

user = User.create!(email: "jpeck@example.com", password: "it's m3?")
if user.persisted?
  log "Created default User"
  log "Email: jpeck@example.com"
  log "Password: it's m3?"
end

log "Done!"