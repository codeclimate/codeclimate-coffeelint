require 'spec_helper'

module CC::Engine
  describe AnalyzableFiles do
    context "when given include_paths" do
      it "filters out non-directory and non-coffee files" do
        analyzable_files = AnalyzableFiles.new({
          "include_paths" => ["foo/", "bar.py", "foo.coffee"]
        })

        expect(analyzable_files.all.sort).to eq(["foo.coffee", "foo/"])
      end
    end

    context "when given exclude_paths" do
      it "raises" do
        analyzable_files = AnalyzableFiles.new({
          "exclude_paths" => []
        })

        expect{analyzable_files.all}.to raise_error
      end
    end
  end
end
