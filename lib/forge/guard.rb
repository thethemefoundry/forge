require 'guard'
require 'guard/guard'

module Forge
  module Guard

    class << self
      attr_accessor :project, :task, :builder
    end

    def self.add_guard(&block)
      @additional_guards ||= []
      @additional_guards << block
    end

    def self.start(project, task, options={}, livereload={})
      @project = project
      @task = task
      @builder = Builder.new(project)

      options_hash = ""
      options.each do |k,v|
        options_hash << ", :#{k} => '#{v}'"
      end

      assets_path = @project.assets_path.gsub(/#{@project.root}\//, '')
      source_path = @project.source_path.gsub(/#{@project.root}\//, '')
      config_file = @project.config_file.gsub(/#{@project.root}\//, '')

      guardfile_contents = %Q{
        guard 'forgeconfig'#{options_hash} do
          watch("#{config_file}")
        end
        guard 'forgeassets' do
          watch(%r{#{assets_path}/javascripts/*})
          watch(%r{#{assets_path}/stylesheets/*})
          watch(%r{#{assets_path}/images/*})
        end
        guard 'forgetemplates' do
          watch(%r{#{source_path}/templates/*})
          watch(%r{#{source_path}/partials/*})
        end
        guard 'forgefunctions' do
          watch(%r{#{source_path}/functions/*})
          watch(%r{#{source_path}/includes/*})
        end
      }

      if @project.config[:livereload]
        guardfile_contents << %Q{
          guard 'livereload' do
            watch(%r{#{source_path}/*})
          end
        }
      end

      (@additional_guards || []).each do |block|
        result = block.call(options, livereload)
        guardfile_contents << result unless result.nil?
      end

      ::Guard.start({ :guardfile_contents => guardfile_contents })
    end
  end
end