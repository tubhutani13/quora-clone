namespace :user do
  desc "Generate auth token for old verified users."
  task :generate_auth_tokens => [:environment] do
    users_updated = User.where(auth_token: nil).where.not(verified_at: nil).each do |user|
      user.generate_token(:auth_token)
      user.save
    end
    if users_updated
      puts "Auth tokens generated for #{users_updated.size} users."
    end
  end
end
