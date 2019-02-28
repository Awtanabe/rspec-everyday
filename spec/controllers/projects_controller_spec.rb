require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do
    describe "#index" do 
      context "認証されているユーザーとして" do 
        before do 
          @user = FactoryBot.create(:user)
        end

        it  "正常にレスポンスを返す" do 
          sign_in @user 
        
          get :index
          
          expect(response).to be_success
        end

        it " 200レスポンスを返す " do
         sign_in @user
         
         get :index 

         expect(response).to have_http_status "200"
        end
      end

      context "ゲストとして" do 
        it "302レスポンスを返す" do
          get :index 
          expect(response).to have_http_status "302"
        end
        
        it "リダイレクト画面に遷移する" do 
          get :index 

          expect(response).to redirect_to  "/users/sign_in"
        end
      end
   end

   describe "show" do 
    context "認可されたユーザーとして" do
       before do 
         @user = FactoryBot.create(:user)
         @project = FactoryBot.create(:project, owner: @user)
       end

       it "正常にレスポンスを返す" do 
         sign_in @user 
         get :show, params: {id: @project.id }
         expect(response).to be_success
       end
    end

    context "認可されていないユーザーとして" do 
      before do 
        @user = FactoryBot.create(:user)
        other_user =FactoryBot.create(:user)
        @project = FactoryBot.create(:project, owner: other_user)
      end

       it "ダッシュボードにリダイレクトすること" do
         sign_in @user 
         get :show, params: {id: @project.id }
            expect(response).to redirect_to root_path 
        end
    end
   end

end
