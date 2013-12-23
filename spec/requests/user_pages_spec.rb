require 'spec_helper'

describe "User pages" do

  subject { page }
  
  before do
	user = User.new(id: 2, name: "test", email: "essai@test.com",
                     password: "test", password_confirmation: "test")
	admin = User.new(id: 999, name: "Example User", email: "example@railstutorial.org",
                     password: "foobar", password_confirmation: "foobar")
	user.save
  end
  

  describe "index" do
  
    let(:user) { User.new(id: 2, name: "test", email: "essai@test.com",
                     password: "test", password_confirmation: "test")}
	before do
	  sign_in user
	  visit users_path
	end

    it { should have_title('All users') }
    it { should have_content('All users') }

    it "should list each user" do
      User.all.each do |user|
        expect(page).to have_selector('li')
      end
    end
	
	describe "delete links" do

      it { should_not have_link('delete') }

      describe "as an admin user" do
        admin = User.new(id: 999, name: "Example User", email: "example@railstutorial.org",
                     password: "foobar", password_confirmation: "foobar")
        before do
          sign_in admin
          visit users_path
        end

       # it { should have_link('delete', href: user_path(User.first)) }
        it "should be able to delete another user" do
     #     expect do
     #       click_link('delete', match: :first)
     #     end.to change(User, :count).by(-1)
        end
        it { should_not have_link('delete', href: user_path(admin)) }
      end
    end
	
  end
  
  describe "signup page" do

    before { visit signup_path }

    let(:submit) { "Create my account" }

    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end
    end

    describe "with valid information" do
      before do
        fill_in "Name",         with: "User"
        fill_in "Email",        with: "user@example.com"
        fill_in "Password",     with: "foobar"
        fill_in "Confirmation", with: "foobar"
      end

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end

	end
	
	describe "after saving the user" do
      before do 		
		fill_in "Name",         with: "Example User 2"
		fill_in "Email",        with: "user2@test.com"
		fill_in "Password",     with: "test2"
		fill_in "Confirmation", with: "test2"
		click_button "Create my account" 
	  end

      it { should have_link('Sign out') }
#      it { should have_title('test2') }
      it { should have_selector('div.alert.alert-success', text: 'Welcome') }
	end
	
    describe "edit" do
	  let(:user) { User.new(id: 2, name: "test", email: "essai@test.com",
                     password: "test", password_confirmation: "test") }
	  before do
		  sign_in user
		  visit edit_user_path(user)
      end

	  describe "page" do
	    it { should have_content("Update your profile") }
	    it { should have_title("Edit user") }
	    it { should have_link('change', href: 'http://gravatar.com/emails') }
	  end

	  describe "with invalid information" do
	    before { click_button "Save changes" }

	    it { should have_content('error') }
	  end
	
	  describe "with valid information" do
        let(:new_name)  { "New Name" }
        let(:new_email) { "new@example.com" }
	  
        before do
          fill_in "Name",             with: new_name
          fill_in "Email",            with: new_email
          fill_in "Password",         with: user.password
          fill_in "Confirm Password", with: user.password
          click_button "Save changes"
        end

        it { should have_title(new_name) }
        it { should have_selector('div.alert.alert-success') }
        it { should have_link('Sign out', href: signout_path) }
        specify { expect(user.reload.name).to  eq new_name }
        specify { expect(user.reload.email).to eq new_email }
      end
	
	end
	
  end
  
end