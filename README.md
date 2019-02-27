# *Everyday Rails Testing with RSpec* sample application (2017 edition)

## 全体p221が最後のアドバイス


# バリデーションが全て通過するかのテストは eq =【be_valid】

# 無効な状態を表現したい 
# 1 インスタンスをvalid?する
# 2 exepct(インスタンス.errors).to include("エラーの文字") 

# 主要なエラーの表現をまとめる
# can't be blank
# has already been taken


#アソシエーション


#  uniqueバリデーションのテスト


# beforeの使い方

全体と、describ毎がある

before do
    # 全テストに該当するテストのデータを記載
  end


## vaklid?かける

[3] pry(#<RSpec::ExampleGroups::Note>)> note.valid?
=> false
[4] pry(#<RSpec::ExampleGroups::Note>)> note.errors
=> #<ActiveModel::Errors:0x007fdf52290638
 @base=
  #<Note:0x007fdf52290c28
   id: nil,
   message: nil,
   project_id: nil,
   user_id: nil,
   created_at: nil,
   updated_at: nil,
   attachment_file_name: nil,
   attachment_content_type: nil,
   attachment_file_size: nil,
   attachment_updated_at: nil>,
 @details=
  {:project=>[{:error=>:blank}],
   :user=>[{:error=>:blank}],
   :message=>[{:error=>:blank}]},
 @messages=
  {:project=>["must exist"], :user=>["must exist"], :message=>["can't be blank"]}>
[5] pry(#<RSpec::ExampleGroups::Note>)> note.errors[:message]
=> ["can't be blank"]


## インスタンス変数でアクセス


note_spec.rb

describe "文字列に一致するメッセージを検索する" do 
    before do 
      @note1 = @project.notes.create(
        message: "First message",
        user: @user,
      )
      @note2 = @project.notes.create(
        message: "Second message",
        user: @user,
      )
      @note3 = @project.notes.create(
        message: "last message",
        user: @user,
      )
   end


# p58までのポイント

期待する結果は能動形で明示的に記述すること。
起きて ほしい ことと、起きて ほしくない ことをテストすること
境界値テストをすること


# p59　テストデータの作成


## factory bot

factorybotとfactorygirlの違い

factorybot
→expect(FactoryBot.build(:user).to be_valid)

factorygirl
→let(:user){create(:user)}

## 用語

シーケンス：並んでる　連続　同時？


## craeteの仕方

- 作成
FactoryBo.creae(:クラス名前)
（キー: バリュー）的な感じか？
- 呼び出し
user

user1 = FactoryBot.create(:user)

## エラー文

can't be blank
 has already been taken

## オーバーライド


- first_name: nil

it "is invalid without a first name" do
user = FactoryBot.build(:user, first_name: nil)
user.valid?
expect(user.errors[:first_name]).to include("can't be blank")
end


## オーバーライドした時のデータ

- オーバーライドしたところ以外は【nil】になるみたい

 it "インスタンスメソッドのテスト with factory bot" do 
      user = FactoryBot.build(:user, first_name: "akifumi", last_name:"watanabe")
  

[1] pry(#<RSpec::ExampleGroups::User>)> user
=> #<User id: nil, email: "text@example.com", created_at: nil, updated_at: nil, first_name: "akifumi", last_name: "watanabe", authentication_token: nil, location: nil>


## シークエンス問題

シークエンス：連続

下記で対応
p67

sequence(:email) { |n| "tester#{n}@example.com" }

# ファクトリで関連を扱う 関連モデル p68


# create_list p65

関連を持つオブジェクトを作成する方法を説明します。Factory Bot にはこうした処理を簡単に行うた めの create_list メソッドが用意


```ruby
/projects.rb

projectを作った後に、noteを作る

trait :with_notes do

# projectが【単数な理由】は、projectが親で、noteが子だから、 projectは【外部キー】　

　after(:create) { |project| create_list(:note, 5, project: project) }
end
```
# 実行
アソシーエーション

```ruby

it "can have many notes" do
  project = FactoryBot.create(:project, :with_notes)
# 　 アソシエーションを組むにはトレイト
  expect(project.notes.length).to eq 5

end
```



## エイリアス

- users.rb

factory :user, aliases: [:owner] do


owner という別名(alias)


## ファクトリ内の重複をなくす p71



## コールバック p64



## 最後のアドバイス

# 自分がやっていることを意識してください


何か作業をするときは、自分が取り組んでいるプロセスを意識してください。そして、紙とペンを使い ながら考えてください。今からやろうとしていることのためにスペックを書きましたか?スペックを使って 境界値テストやエラー発生時のテストを書いていますか?チェックリストを作って、作業中はいつでも 取り出せるようにしておいてくだ

## 解釈
可視化する事は大事


# 小さくコードを書き、小さくテストするのも OK


# 統合スペックを最初に書こうとしてください


モデルスペック　→ コントローラースペック　→　フィーチャスペック　から

## 理想
フィーチャスペック　→ コントローラースペック　→ モデルスペック　

# エンドユーザーがアプリケーションを使ってタスクを完了させる手順を考えて


## よくわからない

# trait p63
トレイト(trait)



# 通常

``` ruby
RSpec.describe Project, type: :model do
  
  
  it "締切日が過ぎていれば遅延していること" do
    project = FactoryBot.create(:project_due_yesterday)
    expect(project).to be_late
  end

  it "締切日が今日ならスケジュールどおりであること" do 
    project = FactoryBot.create(:project_due_today)
    expect(project).to_not be_late
  end
  
  it "締切日が未来ならスケジュールどおりであること" do 
```

# トレイト

```ruby
/projects.rb

FactoryBot.define do
  factory :project do 
    sequence(:name) { |n| "project #{n}"}
    description "a test project"
    due_on 1.week.from_now
    association :owner 
  end


  # 昨日が締め切りのプロジェクト

  trait :due_yesterday, class: Project do 
   due_on 1.day.ago
  end

  # 今日が締め切りのプロジェクト

  trait :due_today, class: Project do 
```

# 実行

```ruby


RSpec.describe Project, type: :model do

# メモ　.create(:project, :due_yesterday)のように、factoryなどで定義している場合の、シンボルは【左に】:
# 　オーバーライドするときは【右に】：
  
  it "締切日が過ぎていれば遅延していること" do
    project = FactoryBot.create(:project, :due_yesterday)
    expect(project).to be_late
  end

  it "締切日が今日ならスケジュールどおりであること" do 
    project = FactoryBot.create(:project, :due_today)
    expect(project).to_not be_late
  end
```



## エイリアス p57

factory :user, aliases: [:owner] do

P71 モデルDE定義してるから RSPECでも明記する必要がある見たい
belongs_to :owner, class_name: User, foreign_key: :user_id

# p69 関連データの作成

を作成する際に関連するユーザー(プロジェクトに関連する owner)を作成し、それから2番目のユー ザー(メモに関連するユーザー)を作成するからです。

#  1.day.ago

[2] pry(main)> 1.day.ago
=> Tue, 26 Feb 2019 13:43:42 UTC +00:00

# Date.current.in_time_zone

[3] pry(main)> Date.current.in_time_zone
=> Wed, 27 Feb 2019 00:00:00 UTC +00:00

# 1.day.from_now

[1] pry(main)> 1.day.from_now
=> Thu, 28 Feb 2019 13:45:54 UTC +00:00

# be_late