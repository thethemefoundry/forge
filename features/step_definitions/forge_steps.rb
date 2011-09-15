Given /^I am in a forge project named "([^"]*)"$/ do |name|
  Forge::Project.create(File.join(current_dir, name), {:name => name}, Forge::CLI.new)
  cd name
end

Given /^a WordPress installation exists at "([^"]*)"$/ do |directory|
  create_dir directory
end

Then /^the file "([^"]*)" should contain:$/ do |filename, content_partials|
  content_partials.raw.each do |content|
    Then "the file \"#{filename}\" should contain \"#{content[0]}\""
  end
end
