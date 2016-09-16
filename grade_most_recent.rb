require 'fileutils'
require 'find'

def clean_path(path)
  File.expand_path(path)
end

def most_recent_zip(dir)
  Dir.glob("#{clean_path(dir)}/*.zip").max_by {|f| File.mtime(f)}
end

def unzip_to_path(zip_path, target_dir)
  `unzip #{clean_path(zip_path)} -d #{clean_path(target_dir)}`
end

def cleanup(dir)
  FileUtils.rm_rf(clean_path(dir), verbose: true)
end

def find_file_by_extension(base_dir, extension)
  file_paths = []
  Find.find(clean_path(base_dir)) do |path|
    file_paths << path if path =~ /.*\.#{extension}$/
  end
  file_paths
end

def find_and_open_single(base_dir, extension)
  files = find_file_by_extension(base_dir, extension)
  raise 'Wrong number of #{extension}: #{files}' if files.size != 1

  to_open = files.first
  puts "Opening #{to_open}"
  `start "" "#{to_open}"`
end


TEMP_DIR = "#{ENV['TMP']}/grading" 

begin
  most_recent = most_recent_zip("#{ENV['USERPROFILE']}/Downloads")
  unzip_to_path(most_recent, TEMP_DIR)

  puts "Opening eval and solution files"
  find_and_open_single(TEMP_DIR, 'docx')
  find_and_open_single(TEMP_DIR, 'sln')

ensure
  puts "Waiting for gradin'"
  gets.chomp

  cleanup(TEMP_DIR)
  cleanup(most_recent)
end
