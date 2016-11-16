require 'spec_helper'

RSpec.describe 'Extractors' do
  context 'extract routes' do
    let(:route_tracer) { RouteTracer::App.new(passphrase: ENV['PASSWORD'])  }

    RouteTracer::App::SOURCES.each do |source_name|
      describe "#{source_name} extractor" do
        let(:zip_data) { VCR.use_cassette(source_name) { route_tracer.data_for_source(source_name).body } }
        let(:subject) { route_tracer.source_extractors[source_name].new(source_name, zip_data) }

        describe '#routes' do
          let(:routes) { subject.routes }

          it 'extracted' do
            expect(routes.count).to be > 0

            routes.each do |route|
              expect(route).to be_kind_of(RouteTracer::Route)
              route_hash = route.to_h
              expect(route_hash[:source]).to eq(source_name)

              %i(start_node start_time end_node end_time).each do |key|
                expect(route_hash[key]).not_to be_nil
              end
            end
          end
        end
      end
    end
  end
end
