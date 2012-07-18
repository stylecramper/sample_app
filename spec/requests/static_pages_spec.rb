require 'spec_helper'

describe 'StaticPages' do
  
  describe 'Home Page' do
    
    describe 'for signed-in users' do
      
      before(:each) do
        @user = Factory(:user)
        @mp1 = Factory(:micropost, :user => @user, :created_at => 1.day.ago)
        @mp2 = Factory(:micropost, :user => @user, :created_at => 1.hour.ago)
        sign_in_user
        visit root_path
      end
      
      it "should render the user's feed" do
        @user.feed.each do |item|
          response.should have_selector("li##{item.id}", :content => item.content)
        end
      end
      
      describe "follower/following counts" do
        
        before(:each) do
          @follower = Factory(:user, :email => Factory.next(:email))
          @follower.follow!(@user)
          visit root_path
        end
        
        it "should have a link to following users page" do
          response.should have_selector('a', :href => following_user_path(@user), :content => ' following')
        end
        
        it "should have a link to followers users page" do
          response.should have_selector('a', :href => followers_user_path(@user), :content => ' followers')
        end
        
      end
      
    end
    
  end
  
end