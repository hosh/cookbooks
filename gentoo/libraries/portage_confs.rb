# Container class for holding all portage_confs

module Utils
  module Gentoo
    class PortageConfs
      @confs = []

      class << self
        def add_conf(conf)
          @confs << conf
        end

        alias << add_conf

        def confs
          @confs.uniq
        end
      end

    end
  end
end
