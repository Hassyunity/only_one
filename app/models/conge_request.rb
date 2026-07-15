class CongeRequest < ApplicationRecord
  belongs_to :employee

  enum :status, { en_attente: "en_attente", approuve: "approuve", refuse: "refuse" }

  validates :leave_type, :starts_on, :ends_on, presence: true

  STATUS_LABELS = {
    "en_attente" => "En attente",
    "approuve" => "Approuvé",
    "refuse" => "Refusé"
  }.freeze

  STATUS_TAG_CLASS = {
    "en_attente" => "tag tag-outline",
    "approuve" => "tag tag-accent",
    "refuse" => "tag tag-neutral"
  }.freeze

  def status_label
    STATUS_LABELS.fetch(status)
  end

  def status_tag_class
    STATUS_TAG_CLASS.fetch(status)
  end

  def dates_label
    FrenchDate.range(starts_on, ends_on)
  end
end
