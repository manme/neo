require 'spec_helper'

RSpec.describe RouteTracer::App do
  let(:subject) { described_class.new(passphrase: ENV['PASSWORD']) }

  context 'trace routes' do
    let(:fetch) { VCR.use_cassette('get_routes') { subject.fetch }}
    let(:send) { VCR.use_cassette('send_routes') { subject.send }}
    before do
      fetch
    end

    describe '#fetch' do
      it 'receive routes' do
        expect(subject.routes.count).to eq(13)
      end
    end

    describe '#send' do
      it 'send routes' do
        expect(send.count).to eq(13)
        expect(send.map(&:status).uniq).to eq([201])
      end
    end
  end
end