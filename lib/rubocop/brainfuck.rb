require 'rubocop'

module RuboCop
  module Brainfuck
    PROJECT_ROOT   = Pathname.new(__dir__).parent.parent.expand_path.freeze
    CONFIG_DEFAULT = PROJECT_ROOT.join('config', 'default.yml').freeze
    CONFIG         = YAML.safe_load(CONFIG_DEFAULT.read).freeze

    private_constant(:CONFIG_DEFAULT, :PROJECT_ROOT)
  end
end

require "rubocop/brainfuck/version"
require "rubocop/brainfuck/inject"

RuboCop::Brainfuck::Inject.defaults!

require 'rubocop/cop/brainfuck/interpreter'
