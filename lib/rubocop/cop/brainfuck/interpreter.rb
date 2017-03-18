# frozen_string_literal: true

module RuboCop
  module Cop
    module Brainfuck
      # This cop check brainfuck program.
      class Interpreter < Cop
        MSG = 'Interpreting the brainfuck code...'.freeze

        def_node_matcher :program?, <<-PATTERN
          (class _ (const {nil cbase} :BrainFuck) $_body)
        PATTERN

        def_node_search :pc,      '(casgn nil :PC $int)'
        def_node_search :code,    '(casgn nil :Code ${str dstr})'
        def_node_search :memory,  '(casgn nil :Memory $array)'
        def_node_search :stdout,  '(casgn nil :Stdout $str)'
        def_node_search :stdin,   '(casgn nil :Stdin $str)'
        def_node_search :pointer, '(casgn nil :Pointer $int)'

        def_node_matcher :int_value, '(int $_)'

        def on_class(node)
          body = program?(node)
          return unless body

          pc = int_value(pc(body).first)
          code = code_value(code(body).first)
          return if code.size <= pc

          add_offense(node, :expression)
        end

        private

        def autocorrect(node)
          body = program?(node)

          pc = pc(body).first
          pc_value = int_value(pc)
          code = code_value(code(body).first)
          memory = memory(body).first
          memory_value = to_array(memory)
          stdout = stdout(body).first
          stdin = stdin(body).first
          pointer = pointer(body).first
          pointer_value = int_value(pointer)

          lambda do |corrector|
            case code[pc_value]
            when '>'
              corrector.replace(
                pointer.loc.expression,
                (int_value(pointer) + 1).to_s
              )
            when '<'
              corrector.replace(
                pointer.loc.expression,
                (int_value(pointer) - 1).to_s
              )
            when '+'
              v = memory_value[pointer_value] || 0
              memory_value[pointer_value] = v == 255 ? 0 : v + 1
              corrector.replace(
                memory.loc.expression,
                memory_value.inspect
              )
            when '-'
              v = memory_value[pointer_value] || 0
              memory_value[pointer_value] = v == 0 ? 255 : v - 1
              corrector.replace(
                memory.loc.expression,
                memory_value.inspect
              )
            when '.'
              str = stdout.str_content + (memory_value[pointer_value] || 0).chr
              corrector.replace(
                stdout.loc.expression,
                str.inspect
              )
            when ','
              char = stdin.str_content.ord rescue 0
              memory_value[pointer_value] = char
              corrector.replace(
                memory.loc.expression,
                memory_value.inspect
              )
              corrector.replace(
                stdin.loc.expression,
                String(stdin.str_content[1..-1]).inspect
              )
            when '['
              v = memory_value[pointer_value] || 0
              if v == 0
                level = 1
                idx = code.chars[(pc_value+1)..-1].index do |code|
                  level += 1 if code == '['
                  level -= 1 if code == ']'
                  level == 0
                end
                pc_value = idx + pc_value + 1
              end
            when ']'
              level = 1
              idx = code.chars[0...pc_value].rindex do |code|
                level += 1 if code == ']'
                level -= 1 if code == '['
                level == 0
              end
              pc_value = idx - 1
            end

            jump(corrector, pc, pc_value+1)
          end
        end

        def code_value(node)
          v =
            case node.type
            when :str
              node.str_content
            when :dstr
              node.children.map(&:str_content).join
            else
              raise
            end
          v.chars.select{|c| %w{> < + - . , [ ]}.include?(c)}.join
        end

        def to_array(node)
          node.children.map{|n| int_value(n)}
        end

        def jump(corrector, pc, v)
          corrector.replace(
            pc.loc.expression,
            v.to_s
          )
        end
      end
    end
  end
end
