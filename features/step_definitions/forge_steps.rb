Given /^I am in a forge project named "([^"]*)"$/ do |name|
  cli = Forge::CLI.new

  cli.shell.mute do
    Forge::Project.create(File.join(current_dir, name), {:name => name}, cli)
  end

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
