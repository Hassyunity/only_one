class StudioProject < ApplicationRecord
  belongs_to :employee, optional: true

  STAGES = [
    { id: "brief", label: "Brief" },
    { id: "encours", label: "En cours" },
    { id: "revision", label: "Révision" },
    { id: "livre", label: "Livré" }
  ].freeze
  STAGE_IDS = STAGES.map { |s| s[:id] }.freeze

  enum :status, STAGE_IDS.index_by(&:itself)

  validates :name, :client, :deadline, presence: true

  def designer_name
    employee&.name || "Non assigné"
  end

  def deadline_label
    FrenchDate.short(deadline)
  end
end
