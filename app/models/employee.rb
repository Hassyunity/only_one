class Employee < ApplicationRecord
  enum :department, { direction: "direction", developpement: "developpement", commercial: "commercial", studio_digital: "studio_digital" }
  enum :status, { actif: "actif", teletravail: "teletravail", conge: "conge" }

  has_many :leads, dependent: :nullify
  has_many :studio_projects, dependent: :nullify
  has_many :dev_tickets, dependent: :nullify
  has_many :conge_requests, dependent: :destroy

  validates :name, :job_title, :department, :status, presence: true

  DEPARTMENT_LABELS = {
    "direction" => "Direction",
    "developpement" => "Développement",
    "commercial" => "Commercial",
    "studio_digital" => "Studio digital"
  }.freeze

  STATUS_LABELS = {
    "actif" => "Actif",
    "teletravail" => "Télétravail",
    "conge" => "Congé"
  }.freeze

  def department_label
    DEPARTMENT_LABELS.fetch(department)
  end

  def status_label
    STATUS_LABELS.fetch(status)
  end

  def status_tag_class
    status == "actif" ? "tag tag-accent" : status == "teletravail" ? "tag tag-outline" : "tag tag-neutral"
  end
end
