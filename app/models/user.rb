class User < ApplicationRecord
  has_secure_password

  enum :role, { direction: "direction", crm: "crm", rh: "rh", studio: "studio", dev: "dev" }

  normalizes :email, with: ->(email) { email.strip.downcase }

  validates :email, presence: true, uniqueness: true
  validates :name, presence: true
  validates :role, presence: true

  ROLE_LABELS = {
    "direction" => "Direction",
    "crm" => "CRM Leads",
    "rh" => "Ressources humaines",
    "studio" => "Studio digital",
    "dev" => "Développeurs"
  }.freeze

  def role_label
    ROLE_LABELS.fetch(role)
  end

  def initials
    name.split.map { |part| part[0] }.join.first(2).upcase
  end

  HOME_ROUTE_HELPERS = {
    "direction" => :direction_path,
    "crm" => :crm_leads_path,
    "rh" => :rh_employees_path,
    "studio" => :studio_projects_path,
    "dev" => :dev_tickets_path
  }.freeze

  def home_path
    Rails.application.routes.url_helpers.public_send(HOME_ROUTE_HELPERS.fetch(role))
  end

  NAV_TABS = {
    "direction" => %w[direction crm rh studio dev],
    "crm" => %w[crm],
    "rh" => %w[rh],
    "studio" => %w[studio],
    "dev" => %w[dev]
  }.freeze

  TAB_LABELS = {
    "direction" => "Direction",
    "crm" => "CRM Leads",
    "rh" => "RH",
    "studio" => "Studio digital",
    "dev" => "Développeurs"
  }.freeze

  def nav_tabs
    NAV_TABS.fetch(role).map do |r|
      { key: r, label: TAB_LABELS.fetch(r), path: Rails.application.routes.url_helpers.public_send(HOME_ROUTE_HELPERS.fetch(r)) }
    end
  end
end
