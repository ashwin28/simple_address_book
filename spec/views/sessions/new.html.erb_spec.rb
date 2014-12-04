require 'rails_helper'

RSpec.describe "sessions/new.html.erb", type: :view do
  subject { page }

  context "rendered content" do
    before { visit login_path() }

    it do 
      should have_selector('h1', text: 'Login')
      should have_title(full_title('Login'))
      should have_field("Username")
      should have_field("Password")
      should have_selector("input[type=submit][value='Login']")
    end
  end
end
