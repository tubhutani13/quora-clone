FactoryBot.define do
  factory :user do
    name { Faker::Name.name}
    email { Faker::Internet.email(name: name , domain: 'quora-clone.com') }
    password {Faker::Internet.password(min_length: 6)}

    trait :admin do
      role { 'admin' }
    end

    trait :with_pass_confirmation do
      password_confirmation { password }
    end
  end
end
