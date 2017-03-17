describe RuboCop::Cop::Brainfuck::Interpreter do
  let(:config) { RuboCop::Config.new }
  subject(:cop) { described_class.new(config) }

  let(:hello_world_source){<<-END.strip_indent}
    class Program < BrainFuck
      PC = 0
      Code = <<-EOS
        +++++++++[>++++++++>+++++++++++>+++++<<<-]>.>++.+++++++..+++.>-.
        ------------.<++++++++.--------.+++.------.--------.>+.
      EOS
      Memory = []
      Stdout = ''
      Stdin = ''
      Pointer = 0
    end
  END

  it 'registers an offense for uncompleted brainfuck program' do
    inspect_source(cop, hello_world_source)
    expect(cop.messages.size).to eq(1)
  end

  it 'hello world' do
    new_source = autocorrect_source_with_loop(cop, hello_world_source)

    expect(new_source).to be_include 'Hello, world!'
  end
end
