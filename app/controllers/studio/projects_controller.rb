module Studio
  class ProjectsController < ApplicationController
    before_action :require_login!
    before_action { require_role!(:studio) }

    def index
      @projects = StudioProject.includes(:employee).order(:deadline).to_a
      @columns = StudioProject::STAGES.map { |stage| column_for(stage) }
      @summary = summary

      total = StudioProject.count
      livre_count = StudioProject.livre.count
      @delivery_rate = total.zero? ? 0 : ((livre_count / total.to_f) * 100).round
      @hero_meta_pills = [ "#{total} projets", "#{StudioProject.where.not(status: "livre").count} en cours" ]
    end

    def move
      @project = StudioProject.find(params[:id])
      previous_stage = @project.status
      @project.update(status: params[:stage]) if StudioProject::STAGE_IDS.include?(params[:stage])

      @projects = StudioProject.includes(:employee).order(:deadline).to_a
      @refreshed_columns = StudioProject::STAGES.select { |s| [ previous_stage, @project.status ].include?(s[:id]) }.map { |s| column_for(s) }
      respond_to { |format| format.turbo_stream }
    end

    private

    def column_for(stage)
      items = @projects.select { |p| p.status == stage[:id] }
      { id: stage[:id], label: stage[:label], items: items, count: items.size }
    end

    def summary
      "#{StudioProject.count} projets suivis · #{StudioProject.where.not(status: "livre").count} en cours"
    end
  end
end
