== 0.4.0 ==
- Added lib to assets folder on generation
- Allow multiple functions files in the source/functions folder, including subfolders

== 0.3.0 ==
- Changed configuration over to Ruby from JSON
- Fixed some bugs that caused forge watch to crash

== 0.2.0 ==
- Added preliminary LESS support
- Added ERB processing on templates, functions and assets with filenames that end with .erb
- Adding --config=filename flag for specifying an alternate config file
- Scaffolding template cleanup

== 0.1.3 ==
- Fixed bug where forge watch crashed when a file was at the root of the includes folder

== 0.1.2 ==
- "build" and "package" commands were not copying includes
- Removing hidden files from includes folder, if they exist
- Updating rack gem - silences the warning it threw in 1.3.4

== 0.1.1 ==
- LiveReload support
- Option for "template" in config, for child themes
- Additions and corrections to config template