class ContactController < ApplicationController
  invisible_captcha only: [:create]

  def new
    @contact_form = ContactForm.new
  end

  def create
    @contact_form = ContactForm.new(contact_form_params)
    @contact_form.remote_ip = request.remote_ip
    @contact_form.browser = request.env['HTTP_USER_AGENT'] if request.env['HTTP_USER_AGENT'].present?

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
    params.require(:contact_form).permit(:name, :mail, :subject, :message)
  end
end
