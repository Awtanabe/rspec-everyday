# *Everyday Rails Testing with RSpec* sample application (2017 edition)



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
    