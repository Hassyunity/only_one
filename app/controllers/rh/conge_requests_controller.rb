module Rh
  class CongeRequestsController < ApplicationController
    before_action :require_login!
    before_action { require_role!(:rh) }
    before_action :set_conge_request

    def approve
      @conge_request.update(status: "approuve")
      respond_to { |format| format.turbo_stream }
    end

    def reject
      @conge_request.update(status: "refuse")
      respond_to { |format| format.turbo_stream }
    end

    private

    def set_conge_request
      @conge_request = CongeRequest.find(params[:id])
    end
  end
end
