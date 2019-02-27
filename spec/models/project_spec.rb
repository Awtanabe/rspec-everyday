require 'rails_helper'

RSpec.describe Project, type: :model do
  #  バリデーション ユニーク制約
  # https://qiita.com/wadako111/items/958dded40a840c35c5ec
  # validates :name, presence: true, uniqueness: { scope: :user_id }
  it "ユーザー単位では重複したプロジェクト名を許可しないこと" do 
     user = User.create(
       first_name: "joe",
       last_name: "tester",
       email: "joea@example",
       password: "dot-nobve",
     )

     user.projects.create(
       name:"Test Project",
     )
      # この記法でいいんだ。。。？
     new_project = user.projects.build(
      name:"Test Project",
     )

     new_project.valid?

     expect(new_project.errors[:name]).to include("has already been taken")

  end

  it "二人のユーザーが同じ名前を使うことは許可すること" do 
    user1 = User.create(
      first_name: "joe",
      last_name: "tester",
      email: "joea@example",
      password: "dot-nobve",
    )

    project1 = user1.projects.create(
      name:"Test Project",
    )

    user2 = User.create(
      first_name: "joe",
      last_name: "tester",
      email: "jo3333a@example",
      password: "dot-nobve",
    )
    
    project2 = user2.projects.build(
      name:"Test Project",
    )
    
    project2.valid?

    expect(project2).to be_valid
  end
  
end
