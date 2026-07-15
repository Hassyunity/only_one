module Crm
  class LeadsController < ApplicationController
    before_action :require_login!
    before_action { require_role!(:crm) }

    FILTERS = [
      { id: "tous", label: "Tous" },
      { id: "setter", label: "Setters" },
      { id: "closer", label: "Closers" }
    ].freeze

    def index
      @filter = FILTERS.map { |f| f[:id] }.include?(params[:filter]) ? params[:filter] : "tous"
      @filters = FILTERS
      @leads = filtered_leads
      @columns = Lead::STAGES.map { |stage| column_for(stage) }
      @summary = summary
      @commercial_employees = Employee.commercial.order(:name)
      @new_lead = Lead.new(owner_type: "setter")

      won = Lead.gagne
      @closing_rate = closing_rate
      @hero_meta_pills = [ "#{Lead.count} prospects", "#{helpers.format_money(won.sum(:value))} gagnés ce mois" ]
    end

    def create
      @filter = FILTERS.map { |f| f[:id] }.include?(params[:filter]) ? params[:filter] : "tous"
      @new_lead = Lead.new(lead_params.merge(stage: "nouveau"))
      if @new_lead.save
        @leads = filtered_leads
        @refreshed_column = column_for(Lead::STAGES.find { |s| s[:id] == "nouveau" })
        @commercial_employees = Employee.commercial.order(:name)
        respond_to { |format| format.turbo_stream }
      else
        @commercial_employees = Employee.commercial.order(:name)
        respond_to { |format| format.turbo_stream { render :create, status: :unprocessable_entity } }
      end
    end

    def move
      @lead = Lead.find(params[:id])
      previous_stage = @lead.stage
      @lead.update(stage: params[:stage]) if Lead::STAGE_IDS.include?(params[:stage])

      @filter = FILTERS.map { |f| f[:id] }.include?(params[:filter]) ? params[:filter] : "tous"
      @leads = filtered_leads
      @refreshed_columns = Lead::STAGES.select { |s| [ previous_stage, @lead.stage ].include?(s[:id]) }.map { |s| column_for(s) }
      respond_to { |format| format.turbo_stream }
    end

    def quick_add
      is_closer_stage = %w[negociation gagne perdu].include?(params[:stage])
      stage_id = Lead::STAGE_IDS.include?(params[:stage]) ? params[:stage] : "nouveau"
      lead = Lead.new(
        name: params[:name].to_s.strip,
        company: "À qualifier",
        value: 0,
        stage: stage_id,
        owner_type: is_closer_stage ? "closer" : "setter"
      )
      return head :unprocessable_entity unless lead.name.present? && lead.save

      @filter = FILTERS.map { |f| f[:id] }.include?(params[:filter]) ? params[:filter] : "tous"
      @leads = filtered_leads
      @refreshed_columns = [ column_for(Lead::STAGES.find { |s| s[:id] == stage_id }) ]
      respond_to { |format| format.turbo_stream }
    end

    private

    def filtered_leads
      scope = Lead.includes(:employee).order(:created_at)
      @filter == "tous" ? scope : scope.where(owner_type: @filter == "setter" ? "setter" : "closer")
    end

    def column_for(stage)
      leads_in = @leads.select { |l| l.stage == stage[:id] }
      {
        id: stage[:id],
        label: stage[:label],
        leads: leads_in,
        count: leads_in.size,
        sum_label: helpers.format_money(leads_in.sum(&:value))
      }
    end

    def summary
      won = Lead.gagne
      "#{Lead.count} prospects · #{helpers.format_money(won.sum(:value))} gagnés ce mois"
    end

    def closing_rate
      won = Lead.gagne.count
      lost = Lead.perdu.count
      total = won + lost
      total.zero? ? 0 : ((won / total.to_f) * 100).round
    end

    def lead_params
      params.require(:lead).permit(:name, :company, :value, :owner_type, :employee_id)
    end
  end
end
