const { getConfig } = require('../../config')
const signer = require('../utils/signer')
const { MichelsonMap } = require('@taquito/taquito')
const { char2Bytes } = require('@taquito/utils')

const originate = async (owner) => {
  const { rpc, code } = await getConfig()
  const Tezos = await signer.getSignerFactory(rpc, owner.sk)

  const metadataJSON = {
    "name": 'InvestaX Preferred Stock',
    "symbol": 'IXPS',
    "decimals": 2,
    "description"   : "Tezos FA1.2 Contract",
    "license":"InvestaX",
    "version":"foo.1.4.2",
        "authors"       : [
        "InvestaX Team <support@investax.io>"
    ],
    "source": {
      "tools": ["Ligo"],
   }, 
    "interfaces"    : [
        "TZIP-007-2021-04-17",
        "TZIP-016-2021-04-17"
    ],
  
    
  }

  const metadataBigMap = new MichelsonMap()
  metadataBigMap.set('', char2Bytes('tezos-storage:contents'))
  metadataBigMap.set('contents', char2Bytes(JSON.stringify(metadataJSON)))

  const origination = await Tezos.contract.originate({
    code,
    storage: {
      owner: owner.pkh,
      totalSupply: 0,
      ledger: new MichelsonMap(),
      whitelist: new MichelsonMap(),
      admins: new MichelsonMap(),
      lockingList: new MichelsonMap(),
      metadata: metadataBigMap,
    }
  })

  const contract = await origination.contract()
  return contract
}

const at = async (address, sender) => {
  const { rpc } = await getConfig()
  const Tezos = await signer.getSignerFactory(rpc, sender.sk)

  const contract = await Tezos.contract.at(address)
  return contract
}

module.exports = { originate, at }
