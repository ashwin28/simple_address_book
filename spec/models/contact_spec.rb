require 'rails_helper'

RSpec.describe Contact, type: :model do

  before { @new_contact = Contact.new(first_name: "Example", last_name: "Contact",
                                      email: "ex_user@exu.com", phone: "123-1234-123",
                                      street: "1 Sunny Lane", city: "Bolton",
                                      state: "Ontario", zip: "L7E 2T2", country: "Canada") }

  it "should respond to the following when valid" do
    %w(first_name last_name email phone street city state zip country).each do |att|
      expect(@new_contact).to respond_to(att.to_sym)
    end

    expect(@new_contact).to be_valid
  end

  context "when only first name is present, it" do
    before { @first_name_contact = Contact.new(first_name: "Example") }
    it { expect(@first_name_contact).to be_valid }
  end

  context "when first name is too short, it" do
    before { @new_contact.first_name = "a" }
    it { expect(@new_contact).not_to be_valid }
  end

  context "when last name is too short, it" do
    before { @new_contact.last_name = "a" }
    it { expect(@new_contact).not_to be_valid }
  end

  context "when email is too long, it" do
    before { @new_contact.email = "#{"a" * 100}.com" }
    it { expect(@new_contact).not_to be_valid }
  end

  context "when email format is wrong, it" do
    it do
      addresses = %w[user@example,com user_at_example.org example.user@foo.
                     foo@bar_baz.com foo@bar+baz.com]
      addresses.each do |invalid_address|
        @new_contact.email = invalid_address
        expect(@new_contact).not_to be_valid
      end
    end
  end

  context "when email format is correct, it" do
    it do
      addresses = %w[user@example.COM EX_US-ER@g.g.org frst.lst@foo.jp win+dow2@baz.cn]
      addresses.each do |valid_address|
        @new_contact.email = valid_address
        expect(@new_contact).to be_valid
      end
    end
  end

  context "email address with mixed case, it" do
    let(:mixed_case_email) { "FoO@ExAMPle.CoM" }

    it "should be saved as all lower-case" do
      @new_contact.email = mixed_case_email
      @new_contact.save
      expect(@new_contact.reload.email).to eq mixed_case_email.downcase
    end
  end

  context "when phone is too long, it" do
    before { @new_contact.phone = "1" * 21 }
    it { expect(@new_contact).not_to be_valid }
  end

  context "when street, city, state and country are too long, it" do
    before do
      %w(street= city= state= country=).each { |method| @new_contact.send(method, "a" * 101) }
    end
    it { expect(@new_contact).not_to be_valid }
  end

  context "when zip is too short, it" do
    before { @new_contact.zip = "1" * 4 }
    it { expect(@new_contact).not_to be_valid }
  end

  context "when zip is too long, it" do
    before { @new_contact.zip = "1" * 11 }
    it { expect(@new_contact).not_to be_valid }
  end
end
