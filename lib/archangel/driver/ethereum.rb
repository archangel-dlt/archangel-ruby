require "archangel/driver/base"
require "ethereum"
require "json"

module Archangel
  module Driver
    class EtherStore < Base
      def initialize(options = { })
        client = Ethereum::HttpClient.new('http://localhost:8545')

        @contract = Ethereum::Contract.create(
          name: "ArchangelDLT",
          abi: @@abi_definition,
          address: @@contract_address,
          client: client
        )
      end

      def store(id, payload, timestamp)
        slug = {
          :id => id,
          :payload => payload,
          :timestamp => timestamp.iso8601
        }
        @contract.transact_and_wait.store(id, slug.to_json.to_str)
      end

      def fetch(id)
        payload, prev = @contract.call.fetch(id)
        parsed = [ JSON.parse(payload) ]

        while (prev != '') do
          payload, prev = @contract.call.fetch_previous(prev)
          parsed.push(JSON.parse(payload))
        end

        parsed
      end

      # These details come from the archangel-ethereum build output
      # The contract is deployed on the Rinkeby test net
      # see https://rinkeby.etherscan.io/address/0x7e9dc20bc8fb81d92305429924f9c0bff6ab9292
      @@contract_address = "0x40aa476f8ae7105d9094e8293b633273c085a3d5"
      @@abi_definition = <<END_ABI
[
    {
      "constant": false,
      "inputs": [
        {
          "name": "addr",
          "type": "address"
        }
      ],
      "name": "grantPermission",
      "outputs": [],
      "payable": false,
      "type": "function"
    },
    {
      "constant": true,
      "inputs": [
        {
          "name": "key",
          "type": "bytes32"
        }
      ],
      "name": "fetchPrevious",
      "outputs": [
        {
          "name": "",
          "type": "string"
        },
        {
          "name": "",
          "type": "bytes32"
        }
      ],
      "payable": false,
      "type": "function"
    },
    {
      "constant": true,
      "inputs": [
        {
          "name": "addr",
          "type": "address"
        }
      ],
      "name": "hasPermission",
      "outputs": [
        {
          "name": "",
          "type": "bool"
        }
      ],
      "payable": false,
      "type": "function"
    },
    {
      "constant": true,
      "inputs": [
        {
          "name": "key",
          "type": "string"
        }
      ],
      "name": "fetch",
      "outputs": [
        {
          "name": "",
          "type": "string"
        },
        {
          "name": "",
          "type": "bytes32"
        }
      ],
      "payable": false,
      "type": "function"
    },
    {
      "constant": false,
      "inputs": [
        {
          "name": "addr",
          "type": "address"
        }
      ],
      "name": "removePermission",
      "outputs": [],
      "payable": false,
      "type": "function"
    },
    {
      "constant": false,
      "inputs": [
        {
          "name": "key",
          "type": "string"
        },
        {
          "name": "payload",
          "type": "string"
        }
      ],
      "name": "store",
      "outputs": [],
      "payable": false,
      "type": "function"
    },
    {
      "inputs": [],
      "payable": false,
      "type": "constructor"
    },
    {
      "anonymous": false,
      "inputs": [
        {
          "indexed": false,
          "name": "_key",
          "type": "string"
        },
        {
          "indexed": false,
          "name": "_payload",
          "type": "string"
        }
      ],
      "name": "Registration",
      "type": "event"
    },
    {
      "anonymous": false,
      "inputs": [
        {
          "indexed": false,
          "name": "_addr",
          "type": "address"
        }
      ],
      "name": "NoWritePermission",
      "type": "event"
    }
]
END_ABI
    end
  end
end
