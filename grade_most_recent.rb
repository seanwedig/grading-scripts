require 'fileutils'
require 'find'
require_relative 'lib/exercise_loader.rb'
require 'pry'
require 'pry-nav'

TEMP_DIR = "#{ENV['TMP']}/grading/lab2" 

loader = Grading::ExerciseLoader.new("#{ENV['USERPROFILE']}/Downloads")

def prompt_yes_no(prompt, default_yes=true) 
  print "#{prompt} y/n "
  puts '[Y]:' if default_yes
  puts '[N]:' unless default_yes

  response = gets.chomp.downcase
  (response == 'y') || (response.empty? && default_yes)
end

most_recent = loader.most_recent_zip
begin
  puts "Grading #{most_recent}"

  puts "Unzipping to #{TEMP_DIR}\n"
  puts "Building the solution..."
  built_prog_path = loader.built_exe_path_for_sln_in(TEMP_DIR)
  puts "Opening eval and solution files"
  loader.open_exercise(TEMP_DIR)

  puts "\n\nRunning it..."
  while prompt_yes_no('Run the program (again)?')
    `start "STUDENT" "#{File.expand_path(built_prog_path)}"`
  end

  puts "\n\nGRADING #{built_prog_path}"
  puts "\n\n...Waiting for gradin'. Hit any key to continue."
rescue Exception => e
  puts "NOOOOO, FAILURE"
  puts e
ensure 
  gets.chomp
  loader.cleanup(TEMP_DIR)

  loader.cleanup(most_recent) if prompt_yes_no("Cleanup downloaded file '#{most_recent}'?")
end
