require "fileutils"

module RSpec
  module Snapshot
    module Matchers
      class MatchSnapShot
        def initialize(metadata, snapshot_name)
          @metadata = metadata
          @snapshot_name = snapshot_name
        end

        def matches?(actual)
          @actual = actual
          filename = "#{@snapshot_name}.snap"
          snap_path = File.join(snapshot_dir, filename)
          update_snapshots = ENV['UPDATE']
          FileUtils.mkdir_p(File.dirname(snap_path)) unless Dir.exist?(File.dirname(snap_path))
          if File.exist?(snap_path) && !update_snapshots
            file = File.new(snap_path)
            @expect = file.read
            file.close
            @actual.to_s == @expect
          else
            reporter_message = update_snapshots ? 'Updating' : 'Generating'
            RSpec.configuration.reporter.message "#{reporter_message} #{snap_path}"
            file = File.new(snap_path, "w+")
            file.write(@actual)
            file.close
            true
          end
        end


        def failure_message
          "\nexpected: #{@expect}\n     got: #{@actual}\n"
        end

        def snapshot_dir
          if RSpec.configuration.snapshot_dir.to_s == 'relative'
            File.dirname(@metadata[:file_path]) << "/__snapshots__"
          else
            RSpec.configuration.snapshot_dir
          end
        end
      end
    end
  end
end
