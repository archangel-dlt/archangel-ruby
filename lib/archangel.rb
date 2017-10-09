require "archangel/version"
require "archangel/driver/base"
require "archangel/driver/filesystem"
require "archangel/driver/guardtime"

module Archangel

  def self.new(driver, options = {})
    driver.new(options)
  end

end
