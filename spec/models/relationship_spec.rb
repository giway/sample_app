require 'spec_helper'

describe Relationship do

  before do
	@user1 = User.new(id: 1, name: "Example User 1", email: "user1@example.com",
                    password: "foobar", password_confirmation: "foobar")
	@user2 = User.new(id: 2, name: "Example User 2", email: "user2@example.com",
                    password: "foobar", password_confirmation: "foobar")
  end

  let(:follower) { @user1 }
  let(:followed) { @user2 }
  let(:relationship) { follower.relationships.build(followed_id: followed.id) }

  subject { relationship }

  it { should be_valid }
  
  describe "follower methods" do
    it { should respond_to(:follower) }
    it { should respond_to(:followed) }
    #its(:follower) { should eq follower }
    #its(:followed) { should eq followed }
  end
  
  describe "when followed id is not present" do
    before { relationship.followed_id = nil }
    it { should_not be_valid }
  end

  describe "when follower id is not present" do
    before { relationship.follower_id = nil }
    it { should_not be_valid }
  end
  
end
