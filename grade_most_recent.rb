require 'fileutils'
require 'find'
require_relative 'lib/exercise_loader.rb'

TEMP_DIR = "#{ENV['TMP']}/grading/lab2" 

loader = Grading::ExerciseLoader.new("#{ENV['USERPROFILE']}/Downloads")

begin
  most_recent = loader.most_recent_zip
  loader.unzip_to_path(most_recent, TEMP_DIR)


  puts "Building the solution..."
  built_prog_path = loader.built_exe_path_for_sln_in(TEMP_DIR)
  puts "Opening eval and solution files"
  loader.open_exercise(TEMP_DIR)

  puts "\n\nRunning it..."
  run_it = true
  while run_it do
    `start "STUDENT" "#{File.expand_path(built_prog_path)}"`
    puts "Run it again? Y/N"
    run_it = gets.chomp.downcase == 'y'
  end

  puts "\n\nGRADING #{built_prog_path}"
  puts "\n\n...Waiting for gradin'. Hit any key to continue."
rescue Exception => e
  puts "NOOOOO, FAILURE"
  puts e
ensure 
  gets.chomp
  loader.cleanup(TEMP_DIR)

  puts "\nCleanup downloaded file '#{most_recent}'? Y/N"
  loader.cleanup(most_recent) if gets.chomp.downcase == 'y'
end
