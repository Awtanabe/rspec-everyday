require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do
    describe "#index" do 
      before do
        @user = FactoryBot.create(:user)
      end  
     it "正常にレスポンスを返すこと" do 
       sign_in @user
         get :index
         expect(response).to be_success
     end

     it "200レスポンスを返すこと" do 
       sign_in @user
         get :index
         expect(response).to have_http_status "200"
      end
   end

end
