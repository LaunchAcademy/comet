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
