class DirectionController < ApplicationController
  before_action :require_login!
  before_action { require_role!(:direction) }

  HISTORICAL_REVENUE = [ 38_000, 44_000, 41_000, 52_000, 47_000 ].freeze
  DEPARTMENTS = %w[developpement commercial studio_digital direction].freeze

  def show
    @won_leads = Lead.gagne
    @lost_leads = Lead.perdu
    @active_leads_count = Lead.where.not(stage: %w[gagne perdu]).count
    @current_month_revenue = @won_leads.sum(:value)
    @closing_rate = closing_rate

    @kpis = kpis
    @revenue_bars = revenue_bars
    @dept_breakdown = dept_breakdown
    @stage_breakdown = stage_breakdown
    @crm_module_stat = "#{@active_leads_count} leads actifs"
    @studio_module_stat = "#{StudioProject.where.not(status: "livre").count} projets actifs"
    @dev_module_stat = "#{DevTicket.where.not(status: "termine").count} tickets ouverts"

    @hero_meta_pills = [
      "CA du mois : #{helpers.format_money(@current_month_revenue)}",
      "Effectif : #{Employee.count}",
      "Automatisations : 14"
    ]
  end

  private

  def closing_rate
    total = @won_leads.count + @lost_leads.count
    return 0 if total.zero?

    ((@won_leads.count / total.to_f) * 100).round
  end

  def stage_breakdown
    values = Lead::STAGES.map { |s| Lead.where(stage: s[:id]).sum(:value) }
    max = [ values.max, 1 ].max
    Lead::STAGES.zip(values).map do |stage, value|
      count = Lead.where(stage: stage[:id]).count
      { label: stage[:label], count: count, sum_label: helpers.format_money(value), pct: "#{((value / max.to_f) * 100).round}%" }
    end
  end

  def kpis
    [
      { label: "CA du mois", value: helpers.format_money(@current_month_revenue), sub: "Deals gagnés" },
      { label: "Leads actifs", value: @active_leads_count.to_s, sub: "Dans le pipeline" },
      { label: "Taux de closing", value: "#{closing_rate}%", sub: "Gagné / (Gagné+Perdu)" },
      { label: "Effectif", value: Employee.count.to_s, sub: "Collaborateurs" },
      { label: "Automatisations", value: "14", sub: "Processus actifs" }
    ]
  end

  def revenue_bars
    months = 5.downto(0).map { |i| Date.current.beginning_of_month - i.months }
    values = HISTORICAL_REVENUE + [ @current_month_revenue ]
    max = [ values.max, 1 ].max

    months.zip(values).map do |month, value|
      {
        month: FrenchDate::ABBREVIATED_MONTHS.fetch(month.month - 1).delete("."),
        value_label: "#{(value / 1000.0).round}k",
        height: "#{[ 6, ((value / max.to_f) * 140).round ].max}px"
      }
    end
  end

  def dept_breakdown
    counts = Employee.group(:department).count
    total = Employee.count
    DEPARTMENTS.map do |dept|
      count = counts.fetch(dept, 0)
      pct = total.zero? ? 0 : ((count / total.to_f) * 100).round
      { label: Employee::DEPARTMENT_LABELS.fetch(dept), count: count, pct: "#{pct}%" }
    end
  end
end
