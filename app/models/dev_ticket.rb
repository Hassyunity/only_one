class DevTicket < ApplicationRecord
  belongs_to :employee, optional: true

  enum :priority, { haute: "haute", moyenne: "moyenne", basse: "basse" }

  STAGES = [
    { id: "backlog", label: "Backlog" },
    { id: "encours", label: "En cours" },
    { id: "revue", label: "Revue de code" },
    { id: "termine", label: "Terminé" }
  ].freeze
  STAGE_IDS = STAGES.map { |s| s[:id] }.freeze

  enum :status, STAGE_IDS.index_by(&:itself)

  validates :title, :priority, :sprint, presence: true

  PRIORITY_TAG_CLASS = {
    "haute" => "tag tag-accent",
    "moyenne" => "tag tag-outline",
    "basse" => "tag tag-neutral"
  }.freeze

  def assignee_name
    employee&.name || "Non assigné"
  end

  def priority_tag_class
    PRIORITY_TAG_CLASS.fetch(priority)
  end
end
