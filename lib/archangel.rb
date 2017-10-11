require 'archangel/version'
require 'archangel/driver/filesystem'
require 'archangel/driver/guardtime'
require 'archangel/driver/guardtimeV2'
require 'archangel/driver/ethereum'

module Archangel
  def self.new(driver, options = {})
    driver.new(options)
  end

end
