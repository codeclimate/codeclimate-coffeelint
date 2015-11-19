require 'spec_helper'
require 'tmpdir'
require 'fileutils'

module CC::Engine
  describe AnalyzableFiles do
    around do |example|
      tmp_dir = Dir.mktmpdir

      Dir.chdir(tmp_dir) do
        example.run
      end

      FileUtils.rm_rf(tmp_dir)
    end

    context 'when config has include_paths' do
      context 'when given explicit paths' do
        it 'returns files matching only those paths' do
          make_file('exclude.coffee')
          make_file('foo/bar.coffee')
          make_file('bar/foo.coffee')

          analyzable_files = AnalyzableFiles.new({
            'include_paths' => ['foo/', 'bar/']
          })
          expect(analyzable_files.all.sort).to eq([
            'bar/foo.coffee',
            'foo/bar.coffee'
          ])
        end
      end

      context 'when given ./' do
        it 'returns all files in the current directory' do
          make_file('root.coffee')
          make_file('foo/bar.coffee')
          make_file('foo/baz/wat.coffee')

          analyzable_files = AnalyzableFiles.new({
            'include_paths' => ['./']
          })
          expect(analyzable_files.all.sort).to eq([
            'foo/bar.coffee',
            'foo/baz/wat.coffee',
            'root.coffee'
          ])
        end
      end
    end

    context 'when config has exclude_paths' do
      it 'excludes files that match exclude_paths' do
        make_file('root.coffee')
        make_file('foo/bar.coffee')
        make_file('bar/foo.coffee')

        analyzable_files = AnalyzableFiles.new({
          'exclude_paths' => ['bar/']
        })
        expect(analyzable_files.all.sort).to eq([
          'foo/bar.coffee',
          'root.coffee'
        ])
      end
    end

    def make_file(name)
      FileUtils.mkdir_p(File.dirname(name))
      File.open(name, 'w') do |f|
        f.write("console.log 'hello!'")
      end
    end
  end
end
