class InvitesController < ApplicationController
  before_filter :find_signature

  def create
    invite = InviteForm.new(invite_params.merge(signature: @signature))

    if invite.deliver
      render json: :ok, status: :ok
    else
      head status: :unprocessable_entity
    end
  end

  private

  def find_signature
    @signature = Signature.find_by(unique_key: params[:signature_id])
  end

  def invite_params
    params.require(:invite_form).permit(:mail)
  end
end
