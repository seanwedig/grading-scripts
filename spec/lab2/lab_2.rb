require 'fileutils'
require_relative '../../lib/exercise_loader.rb'

describe 'Lab2' do
  let(:temp_dir) { "#{ENV['TMP']}/grading/lab2" }

  before do
    FileUtils.mkdir_p(temp_dir)

    loader = Grading::ExerciseLoader.new("#{ENV['USERPROFILE']}/Downloads")
    most_recent = loader.most_recent_zip
    loader.unzip_to_path(most_recent, temp_dir)
  end

  context 'Exercise 12' do
    let(:temp_dir) { "#{super()}/exercise12" }
    let(:reference_prog) { "#{ENV['USERPROFILE']}/Documents/projects/grading-scripts/spec/reference_programs/lab2/Egg.exe" }

    it { puts temp_dir }
  end
end
