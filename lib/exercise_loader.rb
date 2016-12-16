require 'find'

module Grading
  class ExerciseLoader
    MS_BUILD = 'c:/Program Files (x86)/MSBuild/14.0/Bin/MSBuild.exe'

    def initialize(download_dir)
      @download_dir = clean_path(download_dir)
    end

    def most_recent_zip()
      Dir.glob("#{@download_dir}/*.{zip,7z}").max_by {|f| File.mtime(f)}
    end

    def unzip_to_path(zip_path, target_dir)
      `"c:/Program Files/7-Zip/7z.exe" x "#{clean_path(zip_path)}" -o"#{clean_path(target_dir)}"`
    end

    def open_exercise(dir)
      find_and_open_single(dir, 'docx')
      find_and_open_single(dir, 'sln')
    end

    def cleanup(dir)
      FileUtils.rm_rf(clean_path(dir), verbose: true)
    end

    def build_sln_in(dir)
      sln_file = first_by_extension(dir, 'sln')
      system("\"#{MS_BUILD}\" #{sln_file} /t:Clean;Rebuild")
    end

    def built_exe_path_for_sln_in(dir)
      most_recent = most_recent_zip
      unzip_to_path(most_recent, dir)

      build_sln_in(dir)
      first_by_extension(dir, 'exe')
    end

    private

    def clean_path(path)
      File.expand_path(path) 
    end 

    def find_file_by_extension(base_dir, extension)
      file_paths = []
      Find.find(clean_path(base_dir)) do |path|
        file_paths << path if path =~ /.*\.#{extension}$/
      end
      file_paths
    end

    def first_by_extension(base_dir, extension)
      files = find_file_by_extension(base_dir, extension)

      files.first
    end

    def find_and_open_single(base_dir, extension)
      to_open = first_by_extension(base_dir, extension)
      puts "Opening #{to_open}"
      `start "" "#{to_open}"`
    end
  end
end

