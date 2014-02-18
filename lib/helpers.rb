def prompt_for_setting(name, existing_settings)
  if existing_settings.has_key?(name)
    print "#{name.capitalize} (#{existing_settings[name]}): "
  else
    print "#{name.capitalize}: "
  end

  input = gets.chomp.strip

  if !input.empty?
    input
  else
    existing_settings[name]
  end
end

def difficulty_to_string(difficult_rating)
  case difficult_rating
  when 1
    "\e[32measy\e[0m"
  when 2
    "\e[33mintermediate\e[0m"
  when 3
    "\e[31mhard\e[0m"
  else
    ""
  end
end
