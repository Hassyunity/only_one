# This file recreates the demo dataset from the XR Technologie SaaS prototype
# (Claude Design project 56d51be3-5e6b-4d25-a6dc-d5bcaf076bd6), so the app is
# usable right after `bin/rails db:seed`. Safe to run multiple times.

puts "Seeding users…"
DEMO_PASSWORD = "password123"

[
  { email: "direction@xr-technologie.fr", name: "Antoine Girard", role: "direction" },
  { email: "crm@xr-technologie.fr", name: "Marc Dubreuil", role: "crm" },
  { email: "rh@xr-technologie.fr", name: "Élise Rousseau", role: "rh" },
  { email: "studio@xr-technologie.fr", name: "Inès Chevalier", role: "studio" },
  { email: "dev@xr-technologie.fr", name: "Karim Belaïd", role: "dev" }
].each do |attrs|
  User.find_or_create_by!(email: attrs[:email]) do |u|
    u.name = attrs[:name]
    u.role = attrs[:role]
    u.password = DEMO_PASSWORD
  end
end

puts "Seeding employees…"
EMPLOYEES = [
  { name: "Antoine Girard", job_title: "CEO", department: "direction", status: "actif" },
  { name: "Élise Rousseau", job_title: "COO", department: "direction", status: "actif" },
  { name: "Karim Belaïd", job_title: "Lead Developer", department: "developpement", status: "actif" },
  { name: "Sophie Renard", job_title: "Développeuse Backend", department: "developpement", status: "actif" },
  { name: "Yanis Boumediene", job_title: "Développeur Frontend", department: "developpement", status: "teletravail" },
  { name: "Camille Perrot", job_title: "DevOps", department: "developpement", status: "actif" },
  { name: "Marc Dubreuil", job_title: "Closer Senior", department: "commercial", status: "actif" },
  { name: "Nadia El Amrani", job_title: "Setter", department: "commercial", status: "actif" },
  { name: "Thomas Vidal", job_title: "Closer", department: "commercial", status: "conge" },
  { name: "Léa Fontaine", job_title: "Setter", department: "commercial", status: "actif" },
  { name: "Inès Chevalier", job_title: "Directrice Artistique", department: "studio_digital", status: "actif" },
  { name: "Hugo Lambert", job_title: "Motion Designer", department: "studio_digital", status: "actif" },
  { name: "Chloé Marchand", job_title: "UI/UX Designer", department: "studio_digital", status: "teletravail" }
].map { |attrs| Employee.find_or_create_by!(name: attrs[:name]) { |e| e.assign_attributes(attrs) } }
EMPLOYEES_BY_NAME = EMPLOYEES.index_by(&:name)

puts "Seeding leads…"
[
  { name: "StartUp Nova", company: "Nova Studio", value: 8000, stage: "nouveau", owner: "Nadia El Amrani", owner_type: "setter", tags: [ { "label" => "Meta Ads", "color" => "var(--color-neutral-600)" } ] },
  { name: "Atelier Verrier", company: "Atelier Verrier SAS", value: 4500, stage: "nouveau", owner: "Léa Fontaine", owner_type: "setter" },
  { name: "GreenLogix", company: "GreenLogix", value: 12000, stage: "nouveau", owner: "Nadia El Amrani", owner_type: "setter", tags: [ { "label" => "Referral", "color" => "var(--color-accent-2-600)" } ] },
  { name: "Bâtiment Plus", company: "Bâtiment Plus", value: 15000, stage: "qualifie", owner: "Léa Fontaine", owner_type: "setter", tasks_done: 2, tasks_total: 4 },
  { name: "Cabinet Ferrand", company: "Cabinet Ferrand", value: 6200, stage: "qualifie", owner: "Nadia El Amrani", owner_type: "setter" },
  { name: "MedTech Solutions", company: "MedTech Solutions", value: 22000, stage: "qualifie", owner: "Léa Fontaine", owner_type: "setter", tags: [ { "label" => "Urgent", "color" => "var(--color-accent-600)" } ], tasks_done: 1, tasks_total: 3 },
  { name: "Distrib Ouest", company: "Distrib Ouest", value: 9800, stage: "rdv", owner: "Nadia El Amrani", owner_type: "setter", tasks_done: 3, tasks_total: 3 },
  { name: "Cliniques Réunies", company: "Cliniques Réunies", value: 18500, stage: "rdv", owner: "Léa Fontaine", owner_type: "setter", tags: [ { "label" => "Urgent", "color" => "var(--color-accent-600)" } ] },
  { name: "Foncia Immo", company: "Foncia Immo", value: 27000, stage: "negociation", owner: "Marc Dubreuil", owner_type: "closer", tasks_done: 4, tasks_total: 5 },
  { name: "TechCorp Industries", company: "TechCorp Industries", value: 45000, stage: "negociation", owner: "Thomas Vidal", owner_type: "closer", tags: [ { "label" => "Grand compte", "color" => "var(--color-accent-2-600)" } ], tasks_done: 2, tasks_total: 6 },
  { name: "Groupe Delmas", company: "Groupe Delmas", value: 16400, stage: "negociation", owner: "Marc Dubreuil", owner_type: "closer" },
  { name: "Le Comptoir Digital", company: "Le Comptoir Digital", value: 32000, stage: "gagne", owner: "Marc Dubreuil", owner_type: "closer", tasks_done: 5, tasks_total: 5 },
  { name: "Univers Fitness", company: "Univers Fitness", value: 21500, stage: "gagne", owner: "Thomas Vidal", owner_type: "closer", tasks_done: 5, tasks_total: 5 },
  { name: "Pharma Lyon", company: "Pharma Lyon", value: 14000, stage: "perdu", owner: "Marc Dubreuil", owner_type: "closer" }
].each do |attrs|
  owner_name = attrs.delete(:owner)
  Lead.find_or_create_by!(name: attrs[:name]) { |l| l.assign_attributes(attrs.merge(employee: EMPLOYEES_BY_NAME.fetch(owner_name))) }
end

puts "Seeding studio projects…"
[
  { name: "Refonte identité", client: "Lumeo", designer: "Inès Chevalier", deadline: Date.new(2026, 7, 20), status: "brief" },
  { name: "Campagne réseaux", client: "NovaBank", designer: "Hugo Lambert", deadline: Date.new(2026, 7, 25), status: "brief" },
  { name: "Site vitrine", client: "Atelier Verrier", designer: "Chloé Marchand", deadline: Date.new(2026, 7, 18), status: "encours" },
  { name: "Motion intro", client: "TechCorp", designer: "Hugo Lambert", deadline: Date.new(2026, 7, 22), status: "encours" },
  { name: "Refonte app", client: "GreenLogix", designer: "Chloé Marchand", deadline: Date.new(2026, 7, 30), status: "encours" },
  { name: "Brand book", client: "Foncia", designer: "Inès Chevalier", deadline: Date.new(2026, 7, 16), status: "revision" },
  { name: "Vidéo produit", client: "Univers Fitness", designer: "Hugo Lambert", deadline: Date.new(2026, 7, 17), status: "revision" },
  { name: "Landing page", client: "MedTech", designer: "Chloé Marchand", deadline: Date.new(2026, 7, 10), status: "livre" },
  { name: "Charte graphique", client: "Cliniques Réunies", designer: "Inès Chevalier", deadline: Date.new(2026, 7, 8), status: "livre" }
].each do |attrs|
  designer_name = attrs.delete(:designer)
  StudioProject.find_or_create_by!(name: attrs[:name]) { |p| p.assign_attributes(attrs.merge(employee: EMPLOYEES_BY_NAME.fetch(designer_name))) }
end

puts "Seeding dev tickets…"
[
  { title: "Export PDF factures", assignee: "Sophie Renard", priority: "moyenne", sprint: "Sprint 14", status: "backlog" },
  { title: "Refactor auth API", assignee: "Karim Belaïd", priority: "haute", sprint: "Sprint 14", status: "backlog" },
  { title: "Dark mode dashboard", assignee: "Yanis Boumediene", priority: "basse", sprint: "Sprint 14", status: "backlog" },
  { title: "Module RH congés", assignee: "Sophie Renard", priority: "haute", sprint: "Sprint 14", status: "encours" },
  { title: "Kanban leads drag & drop", assignee: "Yanis Boumediene", priority: "haute", sprint: "Sprint 14", status: "encours" },
  { title: "Pipeline CI/CD", assignee: "Camille Perrot", priority: "moyenne", sprint: "Sprint 14", status: "encours" },
  { title: "API reporting Direction", assignee: "Karim Belaïd", priority: "haute", sprint: "Sprint 14", status: "revue" },
  { title: "Notifications temps réel", assignee: "Yanis Boumediene", priority: "moyenne", sprint: "Sprint 14", status: "revue" },
  { title: "Tests e2e module Studio", assignee: "Camille Perrot", priority: "basse", sprint: "Sprint 14", status: "revue" },
  { title: "Auth SSO interne", assignee: "Karim Belaïd", priority: "haute", sprint: "Sprint 13", status: "termine" },
  { title: "Migration base de données", assignee: "Camille Perrot", priority: "haute", sprint: "Sprint 13", status: "termine" },
  { title: "Design system tokens sync", assignee: "Sophie Renard", priority: "moyenne", sprint: "Sprint 13", status: "termine" }
].each do |attrs|
  assignee_name = attrs.delete(:assignee)
  DevTicket.find_or_create_by!(title: attrs[:title]) { |t| t.assign_attributes(attrs.merge(employee: EMPLOYEES_BY_NAME.fetch(assignee_name))) }
end

puts "Seeding conge requests…"
[
  { employee: "Thomas Vidal", leave_type: "Congés payés", starts_on: Date.new(2026, 7, 21), ends_on: Date.new(2026, 7, 25), status: "en_attente" },
  { employee: "Chloé Marchand", leave_type: "Télétravail exceptionnel", starts_on: Date.new(2026, 7, 18), ends_on: Date.new(2026, 7, 18), status: "approuve" },
  { employee: "Yanis Boumediene", leave_type: "RTT", starts_on: Date.new(2026, 7, 22), ends_on: Date.new(2026, 7, 22), status: "en_attente" },
  { employee: "Nadia El Amrani", leave_type: "Congés payés", starts_on: Date.new(2026, 8, 5), ends_on: Date.new(2026, 8, 9), status: "en_attente" }
].each do |attrs|
  employee_name = attrs.delete(:employee)
  employee = EMPLOYEES_BY_NAME.fetch(employee_name)
  CongeRequest.find_or_create_by!(employee: employee, leave_type: attrs[:leave_type], starts_on: attrs[:starts_on]) { |c| c.assign_attributes(attrs) }
end

puts "Done. Comptes de démo (mot de passe : #{DEMO_PASSWORD}) :"
User.order(:role).pluck(:role, :email).each { |role, email| puts "  #{role.ljust(10)} #{email}" }
