require 'spec_helper'

module CC::Engine
  describe Coffeelint do
    describe "#run" do
      let(:mock_io) { double }
      let(:result) do
        {
          './cool.coffee' => [
            {
              "name" => "indentation",
              "value" => 2,
              "level" => "error",
              "message" => "Line contains inconsistent indentation",
              "description" => "",
              "context" => "Expected 2 got 4",
              "lineNumber" => 2,
              "line" => "    if num is 1",
              "rule" => "indentation"
            }
          ]
        }
      end

      let(:second_result) do
        {
          './uncool.coffee' => [
            {
              "name" => "max_line_length",
              "value" => 2,
              "level" => "error",
              "message" => "Line exceeds maximum allowed length",
              "description" => "",
              "context" => "Length is 114, max is 80",
              "lineNumber" => 2,
              "line" => "    if num is 1",
              "rule" => "max_line_length"
            }
          ]
        }
      end

      let(:results) { result.merge(second_result) }

      it "should process results" do
        allow_any_instance_of(CoffeelintResults).to receive(:results).and_return(result)
        allow_any_instance_of(AnalyzableFiles).to receive(:all).and_return(["cool.coffee"])
        expect(mock_io).to receive(:print).
          with("{\"type\":\"Issue\",\"description\":\"Line contains inconsistent indentation\",\"check_name\":\"indentation\",\"categories\":[\"Style\"],\"location\":{\"path\":\"cool.coffee\",\"lines\":{\"begin\":2,\"end\":2}},\"remediation_points\":250000}\u0000")

        Coffeelint.new(directory: '.', io: mock_io, engine_config: {}).run
      end

      describe "with exclude paths config" do
        it "doesn't return excluded files" do
          allow_any_instance_of(CoffeelintResults).to receive(:results).and_return(result)
          expect(mock_io).to receive(:print).never

          Coffeelint.new(
            directory: '.',
            io: mock_io,
            engine_config: {"exclude_paths" => ["cool.coffee"]}
          ).run
        end
      end

      describe "with include paths config" do
        it "returns only included files" do
          allow_any_instance_of(CoffeelintResults).to receive(:results).and_return(results)
          expect(mock_io).to receive(:print).once

          Coffeelint.new(
            directory: '.',
            io: mock_io,
            engine_config: {"include_paths" => ["cool.coffee"]}
          ).run
        end
      end
    end
  end
end
