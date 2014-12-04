require 'rails_helper'

RSpec.describe "users/new.html.erb", type: :view do
  subject { page }

  context "rendered content" do
    before { visit new_user_path() }

    it do 
      should have_selector('h1', text: 'New User')
      should have_title(full_title('New User'))
      should have_field("Username")
      should have_field("Name")
      should have_field("Password")
      should have_field("Password Confirmation")
      should have_selector("input[type=submit][value='Create User']")

      # header links for guest
      should have_link('Simple Address Book', href: root_path)
      should have_link('Sign Up', href: new_user_path)
      should have_link('Login', href: login_path)
    end
  end
end
