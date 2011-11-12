module Tilt
  class LessTemplateWithPaths < LessTemplate
    class << self
      attr_accessor :load_path
    end

    def prepare
      parser = ::Less::Parser.new(:filename => eval_file, :line => line, :paths => [self.class.load_path])
      @engine = parser.parse(data)
    end
  end
end