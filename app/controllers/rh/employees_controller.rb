module Rh
  class EmployeesController < ApplicationController
    before_action :require_login!
    before_action { require_role!(:rh) }

    DEPTS = %w[developpement commercial studio_digital direction].freeze

    def index
      @dept_filters = [ { id: "tous", label: "Tous" } ] + DEPTS.map { |d| { id: d, label: Employee::DEPARTMENT_LABELS.fetch(d) } }
      @dept_filter = @dept_filters.map { |f| f[:id] }.include?(params[:dept]) ? params[:dept] : "tous"
      @search = params[:q].to_s

      employees = Employee.all
      employees = employees.where(department: @dept_filter) unless @dept_filter == "tous"
      employees = employees.where("name LIKE ?", "%#{@search}%") if @search.present?
      @employees = employees.order(:name)

      @dept_breakdown = DEPTS.map { |d| { label: Employee::DEPARTMENT_LABELS.fetch(d), count: Employee.where(department: d).count } }
      @headcount_label = "#{Employee.count} collaborateurs chez #{helpers.company_name}"
      @conge_requests = CongeRequest.includes(:employee).order(created_at: :desc)

      actif_count = Employee.actif.count
      total = Employee.count
      @presence_rate = total.zero? ? 0 : ((actif_count / total.to_f) * 100).round
      @hero_meta_pills = [
        "#{total} collaborateurs",
        "#{@conge_requests.en_attente.count} congés en attente"
      ]
    end
  end
end
