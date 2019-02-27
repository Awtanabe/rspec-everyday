FactoryBot.define do
  factory :user, aliases: [:owner] do
    first_name "Arron"
    last_name "Summer"
    sequence(:email) {|n| "test#{n}@example.coms"}
    password "1234567"
  end
end