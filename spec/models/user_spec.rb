require'rails_helper' 

RSpec.describe User, type: :model do
  

    it "有効なファクトリーを持つ事" do 
     expect(FactoryBot.build(:user)).to be_valid
    end

    it "名がなければ無効な状態であること" do 
      user = FactoryBot.build(:user, first_name: nil)
      
      user.valid?

      expect(user.errors[:first_name]).to include("can't be blank")
    end

    it "インスタンスメソッドのテスト with factory bot" do 
      user = FactoryBot.build(:user, first_name: "akifumi", last_name:"watanabe")
      binding.pry
      expect(user.name).to eq("akifumi watanabe")
    end

 
   it "重複したメールなら無効になる" do 
     user1 = FactoryBot.create(:user, email: "test@example.com") 
     user2 = FactoryBot.build(:user, email: "test@example.com")

     user2.valid?
     
     expect(user2.errors[:email]).to include("has already been taken")
   end


   it "姓、名、メール、パスワードがあれば有効な状態であること" do
     user = User.new(
        first_name: "arron",
        last_name: "summer",
        email: "test@example.com",
        password: "1234567",
     )

     expect(user).to be_valid
   end


   it "名がなければ無効な状態であること" do 
      user = User.new(first_name: nil)
  
      user.valid?

      expect(user.errors[:first_name]).to include("can't be blank")
    

   end
   
   it "姓がなければ無効な状態であること" do 
     user = User.new(last_name: nil)

     user.valid?

     expect(user.errors[:last_name]).to include("can't be blank") 
   end
  
   it "メールアドレスがなければ無効な状態であること" do 
      user = User.new(email: nil)

      user.valid?
 
      expect(user.errors[:email]).to include("can't be blank") 

   end

   
   #  uniqueバリデーションのテスト
   it "重複したメールアドレスなら無効な状態であること" do 
      User.create(
         first_name: "arron",
         last_name: "summer",
         email: "test@example.com",
         password: "1234567",
      )
      user = User.new(
         first_name: "jabe",
         last_name: "sumssser",
         email: "test@example.com",
         password: "342222",
      )
      user.valid?
      expect(user.errors[:email]).to include("has already been taken")
   end


   it "インスタンスメソッド" do 
     user = User.new(
      first_name: "John",
      last_name:  "Doe",
      email:  "johndoe@example.com",
     )
     expect(user.name).to eq "John Doe"
   end
   
end



# バリデーションが全て通過するかのテストは eq =【be_valid】

# 無効な状態を表現したい 
# 1 インスタンスをvalid?する
# 2 exepct(インスタンス.errors).to include("エラーの文字") 

# 主要なエラーの表現をまとめる
# can't be blank
# has already been taken