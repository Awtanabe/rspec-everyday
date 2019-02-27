FactoryBot.define do
  factory :project do 
    sequence(:name) { |n| "project #{n}"}
    description "a test project"
    due_on 1.week.from_now
    association :owner 
  end

  # 昨日が締め切りのプロジェクト

  trait :due_yesterdays do 
   due_on 1.day.ago
  end

  # 今日が締め切りのプロジェクト

  trait :due_todays do 
    due_on Date.current.in_time_zone
   end

  #  明日が締め切りのプロジェクト

  trait :due_tomorrows do 
    due_on 1.day.from_now
   end

  trait :with_notes do 
     after(:create) {|project| create_list(:note, 5, project: project) }   
  end

end
