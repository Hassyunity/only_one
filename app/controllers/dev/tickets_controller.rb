module Dev
  class TicketsController < ApplicationController
    before_action :require_login!
    before_action { require_role!(:dev) }

    def index
      @tickets = DevTicket.includes(:employee).order(:created_at).to_a
      @columns = DevTicket::STAGES.map { |stage| column_for(stage) }
      @summary = summary

      total = DevTicket.count
      termine_count = DevTicket.termine.count
      @completion_rate = total.zero? ? 0 : ((termine_count / total.to_f) * 100).round
      @hero_meta_pills = [ "#{total} tickets", "Sprint 14" ]
    end

    def move
      @ticket = DevTicket.find(params[:id])
      previous_stage = @ticket.status
      @ticket.update(status: params[:stage]) if DevTicket::STAGE_IDS.include?(params[:stage])

      @tickets = DevTicket.includes(:employee).order(:created_at).to_a
      @refreshed_columns = DevTicket::STAGES.select { |s| [ previous_stage, @ticket.status ].include?(s[:id]) }.map { |s| column_for(s) }
      respond_to { |format| format.turbo_stream }
    end

    private

    def column_for(stage)
      items = @tickets.select { |t| t.status == stage[:id] }
      { id: stage[:id], label: stage[:label], items: items, count: items.size }
    end

    def summary
      "#{DevTicket.count} tickets · Sprint 14 en cours"
    end
  end
end
