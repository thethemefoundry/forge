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

      guardfile_contents = %Q{
        guard 'forgeconfig'#{options_hash} do
          watch("config.yml")
        end
        guard 'forgeassets' do
          watch(%r{assets/javascripts/*})
          watch(%r{assets/stylesheets/*})
        end
        guard 'forgetemplates' do
          watch(%r{templates/*})
          watch(%r{partials/*})
        end
        guard 'forgefunctions' do
          watch(%r{functions/*})
        end
      }

      (@additional_guards || []).each do |block|
        result = block.call(options, livereload)
        guardfile_contents << result unless result.nil?
      end

      ::Guard.start({ :guardfile_contents => guardfile_contents })
    end
  end
end