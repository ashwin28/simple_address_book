require 'rails_helper'

RSpec.describe User, type: :model do

  before { @user = User.new(name: "Example User", username: "ex_user",
                            password: "12345678", password_confirmation: "12345678") }

  it "should respond to the following when valid" do
    %w(name username password_digest password
       password_confirmation authenticate contacts).each do |att|
      expect(@user).to respond_to(att.to_sym)
    end

    expect(@user).to be_valid
    expect(@user.contacts.count).to eq(0)
  end

  context "when name is not present, it" do
    before { @user.name = " " }
    it { expect(@user).to be_valid }
  end

  context "when name is too short, it" do
    before { @user.name = "a" }
    it { expect(@user).not_to be_valid }
  end

  context "when username is not present, it" do
    before { @user.username = " " }
    it { expect(@user).not_to be_valid }
  end

  context "when password and confirmation are not present, it" do
    before { @user.password = @user.password_confirmation = " " }
    it { expect(@user).not_to be_valid }
  end

  context "when password doesn't match confirmation, it" do
    before { @user.password_confirmation = "does_not_match" }
    
    it { expect(@user).not_to be_valid }
  end

  context "when password is too short, it" do
    before { @user.password = @user.password_confirmation = "a" * 7 }
    it { expect(@user).not_to be_valid }
  end

  context "when username is already taken, it" do
    before do
      user_with_same_username = @user.dup
      user_with_same_username.username = @user.username
      user_with_same_username.save
    end

    it { expect(@user).not_to be_valid }
  end

  context "return value of authenticate method" do
    before { @user.save }
    let(:same_user) { User.find_by(username: @user.username) }
    let(:user_with_invalid_password) { same_user.authenticate("invalid") }

    it "with a valid password should return the same user" do
      expect(@user).to eq same_user.authenticate(@user.password)
    end

    it "with an invalid password should not return the same user" do
      expect(@user).not_to eq user_with_invalid_password
    end

    it "with an invalid password should be false" do
      expect(user_with_invalid_password).to be_falsey
    end
  end

  context "should be able to add contacts, contacts count" do
    before do
      @user.save
      @user.contacts.create(first_name: "Example", last_name: "Contact",
                            email: "ex_user@exu.com", phone: "123-1234-123",
                            street: "1 Sunny Lane", city: "Bolton", state: "Ontario",
                            zip: "L7E 2T2", country: "Canada")
    end

    it { expect(@user.contacts.count).to eq(1) }
  end

  context "should retrieve contacts by first_name in ascending order where name" do
    before do
      @user.save
      @user.contacts.create(first_name: "Zeus")
      @user.contacts.create(first_name: "Macc")
      @user.contacts.create(first_name: "Alfred", last_name: "Pennyworth")
    end

    it { expect(@user.contacts.first.first_name).to eq("Alfred") }
    it { expect(@user.contacts.last.first_name).to eq("Zeus") }
  end
end
