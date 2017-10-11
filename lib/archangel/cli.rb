require "thor"
require "archangel"
require "date"

class ArchangelCLI < Thor
  class_option :driver, :desc => 'Backend driver to use [file|guardtime|ethereum]. Defaults to file'
  class_option :username, :desc => 'Guardtime username'
  class_option :password, :desc => 'Guardtime password'
  class_option :dir, :desc => 'File storage root directory'

  desc "store ID PAYLOAD", "stores PAYLOAD for ID at the current time"
  def store(id, payload)
    storage().store(id, payload, DateTime.now)
  end # store

  desc "fetch ID", "retrieves the PAYLOAD previously stored with ID"
  def fetch(id)
    puts storage().fetch(id)
  end # fetch

  no_commands do
    def storage()
        Archangel.new(
          driver(options[:driver]),
          {
            :root => options[:dir],
            :username => options[:username],
            :password => options[:password]
          }
        )
    end

    def driver(name)
      case name
      when /^file$/i || /^filesystem$/i
        Archangel::Driver::Filesystem
      when /^guardtime$/i
        Archangel::Driver::GuardtimeV2
      when /^ethereum$/i
        Archangel::Driver::EtherStore
      when nil
        Archangel::Driver::Filesystem
      else
        raise "Unknown driver '#{name}'"
      end
    end # driver
  end # no commands
end
