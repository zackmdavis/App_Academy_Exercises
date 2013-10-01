# What does an auto-grader need to do?
# download attachment
# extract name from filename
# unzip
# run specs
# capture result
# write result to file
# copy files for review

def download_attachment
end

def extract_name(filename)
  filename.split('-')[0]
end

def extract_assessment_number(filename)
  '02' # for the moment
end

def run_specs(filename, assessment_number)
  %x( unzip #{filename} )
  rspec_output = %x( cd assessment#{assessment_number}; rake)
  result_regexp = Regexp.new("(\d+) examples, (\d+) failure")
  examples, failures = rspec_output.match(result_regexp).captures
  successes = (examples.to_i - failures.to_i).to_s
  File.open("assessment#{assessment_number}-scores.txt", 'a') do |f|
    f.puts
end

def write_result(name, failed, passed)
end

def copy_files(name, )
end

def cleanup
end
