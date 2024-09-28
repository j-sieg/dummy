def log(msg)
  puts "[ db/seeds.rb ] #{msg}"
end

if Rails.env.development?
  user = User.create!(email: "jpeck@example.com", password: "it's m3?", confirmed_at: Time.current)
  if user.persisted?
    log "Created default User"
    log "Email: jpeck@example.com"
    log "Password: it's m3?"
  end
end

log "Done!"