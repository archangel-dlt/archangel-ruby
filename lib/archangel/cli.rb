require "thor"
require "archangel"
require "date"

class ArchangelCLI < Thor

  desc "store ID PAYLOAD", "stores PAYLOAD for ID at the current time"
  def store(id, payload)
    archangel = Archangel.new(Archangel::Driver::Filesystem)
    archangel.store(id, DateTime.now, payload)
  end
  
end