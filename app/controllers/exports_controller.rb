class ExportsController < ApplicationController
  before_action :find_petition

  def show
    authorize @petition, :export?

    @signatures = @petition.signatures.order(special: :desc, confirmed_at: :desc).limit(5000)

    respond_to do |format|
      format.pdf
      format.csv
      format.html { redirect_to petition_signatures_url(@petition) }
    end
  end

  private

  def find_petition
    @petition = Petition.friendly.find(params[:petition_id])
  end
end
