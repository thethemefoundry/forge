Then /^the file "([^"]*)" should contain:$/ do |filename, content_partials|
  content_partials.raw.each do |content|
    Then "the file \"#{filename}\" should contain \"#{content[0]}\""
  end
end