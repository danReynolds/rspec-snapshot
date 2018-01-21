module RSpec
  module Snapshot
    class Configuration; end

    def self.initialize_configuration(config)
      config.add_setting :snapshot_dir, :default => :relative
      config.add_setting :update_snapshots, :default => false
    end

    initialize_configuration RSpec.configuration
  end
end
