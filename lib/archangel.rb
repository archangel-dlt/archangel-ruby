require "archangel/version"
require "archangel/driver/base"
require "archangel/driver/filesystem"

module Archangel
  
  def self.new(driver, options = {})
    driver.new(options)
  end
  
end
