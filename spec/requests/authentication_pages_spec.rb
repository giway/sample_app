require 'spec_helper'

describe "Authentication" do

  subject { page }
  
  before do
	user = User.new(id: 316, name: "test", email: "essai@test.com",
                     password: "test", password_confirmation: "test")
	user.save
  end

  describe "signin" do
    before { visit signin_path }

    describe "with invalid information" do
      before { click_button 'Sign in' }

      it { should have_title('Sign in') }
      it { should have_selector('div.alert.alert-error', text: 'Invalid') }
	  
	  describe "after visiting another page" do
        before { click_link "Home" }
        it { should_not have_selector('div.alert.alert-error') }
      end
	  
    end
	
	describe "with valid information" do
      let(:user) { User.new(id: 316, name: "test", email: "essai@test.com",
                     password: "test", password_confirmation: "test") }
	  before { sign_in user }

      it { should have_title(user.name) }
      #it { should have_link('Profile',     href: users_path(user)) }
      #it { should have_link('Settings',    href: edit_user_path(user)) }
      it { should have_link('Sign out',    href: signout_path) }
      it { should_not have_link('Sign in', href: signin_path) }
	  
	  describe "followed by signout" do
        before { click_link "Sign out" }
        it { should have_link('Sign in') }
      end
	  
    end
	
  end
  
  describe "authorization" do

    describe "for non-signed-in users" do
      let(:user) { User.new(id: 316, name: "test", email: "essai@test.com",
                     password: "test", password_confirmation: "test") }
					 
	  describe "when attempting to visit a protected page" do
        before do
          visit edit_user_path(user)
          fill_in "Email",    with: user.email
          fill_in "Password", with: user.password
          click_button "Sign in"
        end

        describe "after signing in" do

          it "should render the desired protected page" do
            expect(page).to have_title('Edit user')
          end
        end
      end

      describe "in the Users controller" do

        describe "visiting the edit page" do
          before { visit edit_user_path(user) }
          it { should have_title('Sign in') }
        end

        describe "submitting to the update action" do
          before { patch user_path(user) }
          specify { expect(response).to redirect_to(signin_path) }
        end
		
		describe "visiting the user index" do
          before { visit users_path }
          it { should have_title('Sign in') }
        end
		
      end
    end
	
	describe "as wrong user" do
      let(:user) { User.new(id: 317, name: "test2", email: "essai2@test.com",
                     password: "test2", password_confirmation: "test2") }
      let(:wrong_user) { User.new(id: 318, name: "test", email: "wrongmail@test.com",
                     password: "test", password_confirmation: "test") }
      before { sign_in user, no_capybara: true }

      describe "submitting a GET request to the Users#edit action" do
        before { get edit_user_path(wrong_user) }
        specify { expect(response.body).not_to match(full_title('Edit user')) }
        specify { expect(response).to redirect_to(signin_url) }
      end

      describe "submitting a PATCH request to the Users#update action" do
        before { patch user_path(wrong_user) }
       specify { expect(response).to redirect_to(signin_url) }
      end
    end
	
	describe "as non-admin user" do
      let(:user) { User.new(id: 317, name: "test2", email: "essai2@test.com",
                     password: "test2", password_confirmation: "test2") }
      let(:non_admin) { User.new(id: 318, name: "test", email: "wrongmail@test.com",
                     password: "test", password_confirmation: "test") }

      before { sign_in non_admin, no_capybara: true }

      describe "submitting a DELETE request to the Users#destroy action" do
        before { delete user_path(user) }
        specify { expect(response).to redirect_to(signin_url) }
      end
    end
	
  end
  
end