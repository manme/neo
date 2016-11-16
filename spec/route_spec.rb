require 'spec_helper'

RSpec.describe RouteTracer::Route do
  let(:subject) { described_class.new(source, start_node, dt_start, end_node, dt_end) }
  let(:start_node) { 'n1' }
  let(:end_node) { 'n2' }
  let(:source) { :source }
  let(:dt_start) { DateTime.new(2001, 2, 3, 4, 5, 6) }
  let(:dt_end) { DateTime.new(2001, 3, 3, 4, 5, 6) }
  let(:dt_start_f) { '2001-02-03T04:05:06' }
  let(:dt_end_f) { '2001-03-03T04:05:06' }

  describe '#to_h' do
    it 'serialize' do
      expect(subject.to_h).to eq({ start_node: start_node,
        start_time: dt_start_f,
        end_node: end_node,
        end_time: dt_end_f,
        source: source })
    end
  end
end