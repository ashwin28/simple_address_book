class ContactsController < ApplicationController
  before_action :authenticate, :set_user
  before_action :set_contact, only: [:show, :edit, :update, :destroy]

  def new
    @contact = @user.contacts.new
  end

  def create
    @contact = @user.contacts.new(contact_params)
    if @contact.save
      redirect_to @user, notice: 'Contact was successfully created.'
    else
      render action: :new
    end
  end

  def update
    if @contact.update(contact_params)
      redirect_to @user, notice: 'Contact was successfully updated.'
    else
      render action: :edit
    end
  end

  def destroy
    @contact.destroy
    redirect_to @user, notice: 'Contact was successfully deleted.'
  end

  private
    def set_user
      @user = current_user
    end

    def set_contact
      @contact = Contact.find_by(id: params[:id], user_id: @user)
    end

    def contact_params
      params.require(:contact).permit(:first_name, :last_name, :email, :phone,
                                      :street, :city, :state, :zip, :country)
    end
end
