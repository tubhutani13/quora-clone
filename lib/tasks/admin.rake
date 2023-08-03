namespace :admin do
  desc "TODO"
  task new: :environment do
    puts "Enter Name"
    name = STDIN.gets.chomp
    puts "Enter Email"
    email = STDIN.gets.chomp
    puts "Enter Password"
    password = STDIN.gets.chomp
    puts "Enter Password Confirm"
    password_confirmation = STDIN.gets.chomp

    user = User.create(
      :name => name.to_s,
      :email => email.to_s,
      :password => password.to_s,
      :password_confirmation => password_confirmation.to_s,
      :verified_at => Time.now,
    )
    if user.save
      puts "success"
    else
      puts "error"
      puts user.errors.full_messages
    end
  end
end
