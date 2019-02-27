FactoryBot.define do
  factory :note do 
    message  "My importnt note"
    association :project
    user { project.owner }
  end
end