class ContactController < ApplicationController
  def new
    @contact_form = ContactForm.new
  end

  def create
    @contact_form = ContactForm.new(contact_form_params)

    if @contact_form.deliver
      redirect_to contact_thanks_url
    else
      render :new
    end
  end

  def thanks
  end

  private

  def contact_form_params
    params.require(:contact_form).permit(:name, :mail, :message)
  end
end
