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
    check_file_content(filename, content[0], true)
  end
end

Then /^the forge skeleton should be created in directory "([^"]*)"$/ do |base_dir|
  skeleton_dirs = [
    ['assets', 'images'],
    ['assets', 'javascripts'],
    ['assets', 'stylesheets'],

    ['functions'],

    ['templates', 'core'],
    ['templates', 'custom', 'pages'],
    ['templates', 'custom', 'partials']
  ]

  skeleton_dirs.each do |skeleton_dir|
    full_path = File.join(base_dir, skeleton_dir)
    check_directory_presence([full_path], true)
  end
end