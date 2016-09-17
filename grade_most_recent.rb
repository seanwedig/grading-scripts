require 'fileutils'
require 'find'
require_relative 'lib/exercise_loader.rb'

TEMP_DIR = "#{ENV['TMP']}/grading" 

unpacker = Grading::ExerciseLoader.new("#{ENV['USERPROFILE']}/Downloads")

begin
  most_recent = unpacker.most_recent_zip
  unpacker.unzip_to_path(most_recent, TEMP_DIR)

  puts "Opening eval and solution files"
  unpacker.open_exercise(TEMP_DIR)

  puts "\n\n...Waiting for gradin'. Hit any key to continue."
rescue
  puts "NOOOOO, FAILURE"
ensure 
  gets.chomp
  unpacker.cleanup(TEMP_DIR)

  puts "\nCleanup downloaded file '#{most_recent}'? Y/N"
  unpacker.cleanup(most_recent) if gets.chomp.downcase == 'y'
end
