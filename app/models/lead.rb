class Lead < ApplicationRecord
  belongs_to :employee, optional: true

  enum :owner_type, { setter: "setter", closer: "closer" }

  STAGES = [
    { id: "nouveau", label: "Nouveau lead" },
    { id: "qualifie", label: "Qualifié" },
    { id: "rdv", label: "RDV pris" },
    { id: "negociation", label: "Négociation" },
    { id: "gagne", label: "Gagné" },
    { id: "perdu", label: "Perdu" }
  ].freeze
  STAGE_IDS = STAGES.map { |s| s[:id] }.freeze

  enum :stage, STAGE_IDS.index_by(&:itself)

  validates :name, :company, :owner_type, presence: true
  validates :value, numericality: { greater_than_or_equal_to: 0 }

  def stage_label
    STAGES.find { |s| s[:id] == stage }.fetch(:label)
  end

  def owner_name
    employee&.name || "Non assigné"
  end

  def owner_tag_class
    closer? ? "tag tag-accent" : "tag tag-neutral"
  end

  def tasks?
    tasks_total.to_i.positive?
  end

  def tasks_label
    "#{tasks_done}/#{tasks_total}"
  end
end
