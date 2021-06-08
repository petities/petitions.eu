class IrmaController < ApplicationController
  include IrmaHelper

  
  def login_jwt
    render plain: irma_jwt_create
  end
end
