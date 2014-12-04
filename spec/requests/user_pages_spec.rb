require 'rails_helper'
include ApplicationHelper

RSpec.describe "UserPages", type: :request do
  let(:user) { User.new(name: "Example User", username: "ex_user",
                        password: "12345678", password_confirmation: "12345678") }
  subject { page }

  context "creating a user with valid information" do
    before do
      visit new_user_path
      fill_in 'Username',              with: user.username
      fill_in 'Name',                  with: user.name
      fill_in 'Password',              with: user.password
      fill_in 'Password Confirmation', with: user.password
    end

    it "should create a user and allow CRUD options for contacts" do
      # check user show page
      expect { click_button('Create User') }.to change(User, :count).by(1)
      should have_selector('div#flash-div', text: "Your account was successfully created.")
      should have_title(full_title('Contact List'))
      should have_selector('h1', text: "Welcome #{user.name}")
      should have_selector('h2', text: "You currently have #{User.first.contacts.count} contacts:")
      should have_link('Add New Contact', href: new_user_contact_path(User.first))

      # check header links after login
      should have_link('Simple Address Book', href: root_path)
      should have_link('Edit Profile', href: edit_user_path(User.first))
      should have_link('Logout', href: logout_path)

      should_not have_link('Google+', href: '/auth/google_oauth2')
      should_not have_link('Sign Up', href: new_user_path)
      should_not have_link('Login', href: login_path)

      # check adding a new contact
      expect { 
        click_link 'Add New Contact'
        fill_in 'First Name', with: "Demo"
        fill_in 'Last Name',  with: "User"
        click_button 'Create Contact'
      }.to change(Contact, :count).by(1)

      # check updated user show page
      expect { current_path.to eq(user_path(User.first)) }
      expect(User.first.contacts.count).to eq(1)
      should have_selector('div#flash-div', text: "Contact was successfully created.")
      should have_selector('h2', text: "You currently have #{User.first.contacts.count} contact:")
      should have_link('Demo', href: user_contact_path(User.first, User.first.contacts[0]))
      should have_link('Edit', href: edit_user_contact_path(User.first, User.first.contacts[0]))
      should have_link('Delete', href: user_contact_path(User.first, User.first.contacts[0]))

      # this link is contact's name
      click_link 'Demo'

      # check contact show page
      expect { current_path.to eq(user_contact_path(User.first, User.first.contacts[0])) }
      should have_selector('h1', text: "View Contact")
      should have_title(full_title('View Contact'))
      should_not have_link('Demo', href: user_contact_path(User.first, User.first.contacts[0]))
      should have_link('Edit', href: edit_user_contact_path(User.first, User.first.contacts[0]))
      should have_link('Delete', href: user_contact_path(User.first, User.first.contacts[0]))
      should have_link('Back', href: user_path(User.first))

      # check contact edit page
      click_link 'Edit'
      
      expect { current_path.to eq(edit_user_contact_path(User.first, User.first.contacts[0])) }
      should have_title(full_title('Edit Contact'))
      should have_selector('h1', text: "Edit Contact")

      # check edit form, also the same form used for new contact
      should have_field("First Name")
      should have_field("Last Name")
      should have_field("Email")
      should have_field("Phone")
      should have_field("Street")
      should have_field("City")
      should have_field("State")
      should have_field("Zip")
      should have_field("Country")
      should have_selector("input[type=submit][value='Update Contact']")
      should have_link('Back', href: user_path(User.first))

      # check update contact
      expect { 
        fill_in 'First Name', with: "Updated First Name"
        click_button 'Update Contact'
      }.to change(Contact, :count).by(0)

      # check updated contact and show page
      expect(User.first.contacts[0].first_name).to eq("Updated First Name")
      should have_selector('div#flash-div', text: "Contact was successfully updated.")
      should_not have_link('Demo', href: user_contact_path(User.first, User.first.contacts[0]))
      should have_link('Updated First Name', href: user_contact_path(User.first, User.first.contacts[0]))

      expect { click_link 'Delete' }.to change(Contact, :count).by(-1)

      # check contact delete and user show page
      expect { current_path.to eq(user_path(User.first)) }
      expect(User.first.contacts.count).to eq(0)
      should have_selector('div#flash-div', text: "Contact was successfully deleted.")
      should have_selector('h2', text: "You currently have #{User.first.contacts.count} contacts:")

      # check edit user page
      click_link 'Edit Profile'
      
      expect { current_path.to eq(edit_user_path(User.first)) }
      should have_title(full_title('Edit Your Profile'))
      should have_selector('h1', text: "Edit Your Profile")
      should have_link('Back', href: user_path(User.first))

      # update user's name
      expect { 
        fill_in 'Username',              with: user.username
        fill_in 'Name',                  with: "Updated Name"
        fill_in 'Password',              with: user.password
        fill_in 'Password Confirmation', with: user.password
        click_button 'Update User'
      }.to change(User, :count).by(0)

      # check updated user show page
      expect { current_path.to eq(user_path(User.first)) }
      should have_selector('div#flash-div', text: "Your user information was successfully updated.")
      should_not have_selector('h1', text: "Welcome #{user.name}")
      should have_selector('h1', text: "Welcome Updated Name")

      # check user logout
      click_link 'Logout'
      
      expect { current_path.to eq(login_path) }
      should have_selector('div#flash-div', text: "You successfully logged out.")
      should_not have_link('Edit Profile', href: edit_user_path(User.first))
      should_not have_link('Logout', href: logout_path)
      should have_link('Google+', href: '/auth/google_oauth2')
      should have_link('Sign Up', href: new_user_path)
      should have_link('Login', href: login_path)

      # check for redirect when trying to view user show while logged out
      visit user_path(User.first.id)

      expect { current_path.to eq(login_path) }
      should have_selector('div#flash-div', text: "Please log in to continue.")

      # check user login
      fill_in 'Username', with: user.username
      fill_in 'Password', with: user.password
      click_button 'Login'

      expect { current_path.to eq(user_path(User.first)) }
      should have_selector('div#flash-div', text: "You successfully logged in.")
    end
  end
end
