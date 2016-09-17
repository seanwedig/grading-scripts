require 'fileutils'
require_relative '../../lib/exercise_loader.rb'

describe 'Lab2' do
  let(:temp_dir) { "#{ENV['TMP']}/grading/lab2" }
  let(:loader) { Grading::ExerciseLoader.new("#{ENV['USERPROFILE']}/Downloads") }
  let!(:student_prog_path) { loader.built_exe_path_for_sln_in(temp_dir) }

  before do
    FileUtils.mkdir_p(temp_dir)

    puts "\n\nGRADING '#{student_prog_path}\n\n"
  end

  after do
    loader.cleanup(temp_dir)
  end

  context 'Exercise 12' do
    let(:temp_dir) { "#{super()}/exercise12" }
    let(:reference_prog) { "#{ENV['USERPROFILE']}/Documents/projects/grading-scripts/spec/reference_programs/lab2/Egg.exe" }

    it { true }
  end
end
