require 'fileutils'
require 'find'

require_relative 'lib/exercise_loader.rb'

def cleanup(dir)
  FileUtils.rm_rf(clean_path(dir), verbose: true)
end


TEMP_DIR = "#{ENV['TMP']}/grading" 

begin
  unpacker = Grading::ExerciseLoader.new("#{ENV['USERPROFILE']}/Downloads")

  most_recent = unpacker.most_recent_zip
  unpacker.unzip_to_path(most_recent, TEMP_DIR)

  puts "Opening eval and solution files"
  unpacker.open_exercise(TEMP_DIR)

  puts "Waiting for gradin'"
rescue e
  puts "NOOOOO, FAILURE"
  puts e
ensure 
  gets.chomp

  cleanup(TEMP_DIR)
  cleanup(most_recent)
end
