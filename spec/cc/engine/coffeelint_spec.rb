require 'spec_helper'
require 'tmpdir'

module CC::Engine
  describe Coffeelint do
    around do |example|
      tmp_dir = Dir.mktmpdir

      Dir.chdir(tmp_dir) do
        example.run
      end

      FileUtils.rm_rf(tmp_dir)
    end

    describe "#run" do
      it "prints out results when include paths is ./" do
        make_file("foo.coffee", "a" * 90)
        make_file("bar.coffee", "a" * 90)
        io = double(print: nil)

        Coffeelint.new(
          directory: Dir.pwd,
          io: io,
          engine_config: { "include_paths" => ["./"] }
        ).run

        expect(io).to have_received(:print).twice
      end

      it "prints out results for specific files and folders" do
        make_file("foo.coffee", "a" * 90)
        make_file("wat.coffee", "a" * 90)
        make_file("bar.coffee", "a" * 90)
        make_file("baz/other.coffee", "a" * 90)
        io = double(print: nil)

        Coffeelint.new(
          directory: Dir.pwd,
          io: io,
          engine_config: {
            "include_paths" => ["baz/", "foo.coffee", "wat.coffee"]
          }
        ).run

        expect(io).to have_received(:print).exactly(3).times
      end

      it "prints out no results if there are no analyzable files" do
        make_file("foo.rb", "a" * 90)
        io = double(print: nil)

        Coffeelint.new(
          directory: Dir.pwd,
          io: io,
          engine_config: {
            "include_paths" => ["foo.rb"]
          }
        ).run

        expect(io).to have_received(:print).exactly(0).times
      end

      it "prints out the proper message" do
        make_file("foo.coffee", "a" * 90)
        io = double(print: nil)

        Coffeelint.new(
          directory: Dir.pwd,
          io: io,
          engine_config: {
            "include_paths" => ["foo.coffee"]
          }
        ).run

        expect(io).to have_received(:print).once.with("{\"type\":\"Issue\",\"description\":\"Line exceeds maximum allowed length\",\"check_name\":\"max_line_length\",\"categories\":[\"Style\"],\"location\":{\"path\":\"foo.coffee\",\"lines\":{\"begin\":1,\"end\":1}},\"remediation_points\":50000}\u0000")
      end

      it "works with files that have spaces" do
        make_file("foo bar.coffee", "a" * 90)
        io = double(print: nil)

        Coffeelint.new(
          directory: Dir.pwd,
          io: io,
          engine_config: {
            "include_paths" => ["./"]
          }
        ).run

        expect(io).to have_received(:print).once
      end
    end

    def make_file(name, contents = "true")
      FileUtils.mkdir_p(File.dirname(name))
      File.open(name, 'w') do |f|
        f.write(contents)
      end
    end
  end
end
