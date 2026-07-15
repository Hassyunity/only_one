module FrenchDate
  ABBREVIATED_MONTHS = %w[jan. fév. mars avr. mai juin juil. août sept. oct. nov. déc.].freeze
  FULL_MONTHS = %w[janvier février mars avril mai juin juillet août septembre octobre novembre décembre].freeze

  module_function

  def short(date)
    "#{date.day} #{ABBREVIATED_MONTHS.fetch(date.month - 1)}"
  end

  def range(starts_on, ends_on)
    if starts_on == ends_on
      "#{starts_on.day} #{FULL_MONTHS.fetch(starts_on.month - 1)}"
    elsif starts_on.month == ends_on.month
      "#{starts_on.day}–#{ends_on.day} #{FULL_MONTHS.fetch(ends_on.month - 1)}"
    else
      "#{short(starts_on)} – #{short(ends_on)}"
    end
  end
end
