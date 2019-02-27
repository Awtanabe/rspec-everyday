require 'rails_helper'

RSpec.describe Note, type: :model do
  

  before do
    # 全テストに該当するテストのデータを記載

    @user = User.create(
      first_name: "joe",
      last_name: "tester",
      email: "text@example.com",
      password: "12345679"
    )

    @project = @user.projects.create(
      name:"Test Project",
    )
  end


  it "ユーザー、プロジェクト、メッセージがあれば有効な状態であること" do 
    note = Note.new(
      message: " this is message",
      user: @user,
      project: @project,
    )

    expect(note).to be_valid
  end

  it " メッセージがなければ無効な状態であること" do 
    note = Note.new(message: nil) 
    
    note.valid?
  
    expect(note.errors[:message]).to include("can't be blank") 

  end


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
    
   context "一致するデータが見つかるとき" do 
    it{expect(Note.search("first")).to include(@note1)} 
   end

   context "一致するデータが見つからない時" do 
    it{expect(Note.search("third")).to be_empty }
   end


  end
   
  describe '字列に一致するメッセージを検索する' do
    before do 
      # 検索機能の周りのテストテストデータ   
    end
    context "一致するデータが見つかるとき" do 

    end

    context "一致するデータが見つからない時" do 

    end

  end


  it " 検索文字列に一致するメモを返すこと" do 

    user = User.create(
      first_name: "akifumi",
      last_name: "kannda", 
      email: "test@example.com",
      password: "1234567",
    )

    project = user.projects.create(
      name:"Test Project",
    )

    note1 = project.notes.create(
      message:"This is the first note",
      user: user,
    )
    note2 = project.notes.create(
      message:"First is the second note",
      user: user,
    )

    note3 = project.notes.create(
      message:"This is the third note",
      user: user,
    )

    note4 = project.notes.create(
      message:"This is the third note",
      user: user,
    )

    expect(Note.search("first")).to include(note1, note2)
    expect(Note.search("first")).not_to include(note3)
    
    expect(Note.search("secone")).to be_empty
  
  end
  
end
