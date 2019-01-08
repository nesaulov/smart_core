# frozen_string_literal: true

describe SmartCore::Operation do
  specify 'smoke test' do
    class SimpleOp < SmartCore::Operation
      param :a
      param :b

      option :c
      option :e
      option :d, default: 'lol'
      option :u, default: -> { 1 + 1 }
    end

    # rubocop:disable Metrics/LineLength
    expect { SimpleOp.new }.to raise_error(SmartCore::Operation::ParameterError)
    expect { SimpleOp.new(1) }.to raise_error(SmartCore::Operation::ParameterError)
    expect { SimpleOp.new(1, 'test') }.to raise_error(SmartCore::Operation::OptionError)
    expect { SimpleOp.new(1, 'test', c: 5.5) }.to raise_error(SmartCore::Operation::OptionError)
    expect { SimpleOp.new(1, 'test', e: 20) }.to raise_error(SmartCore::Operation::OptionError)
    expect { SimpleOp.new('test', c: 22, e: 3.5) }.to raise_error(SmartCore::Operation::ParameterError)
    expect { SimpleOp.new('kek', 55, c: 'test', e: 2.1) }.not_to raise_error
    # rubocop:enable Metrics/LineLength

    operation = SimpleOp.new('kek', 5.5, c: 'chebu', e: 123)

    expect(operation.a).to eq('kek')
    expect(operation.b).to eq(5.5)
    expect(operation.c).to eq('chebu')
    expect(operation.e).to eq(123)
    expect(operation.d).to eq('lol')
    expect(operation.u).to eq(2)

    result = operation.call
    expect(result.success?).to eq(true)
    expect(result.failure?).to eq(false)

    result = SimpleOp.call('atata', 5.5, c: 22, e: '123', d: nil, u: 2)
    expect(result.success?).to eq(true)
    expect(result.failure?).to eq(false)
  end
end
