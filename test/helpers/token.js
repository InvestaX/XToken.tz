const { getConfig } = require('../../config')
const signer = require('../utils/signer')
const { MichelsonMap } = require('@taquito/taquito')

const originate = async (owner) => {
  const { rpc, code } = await getConfig()
  const Tezos = await signer.getSignerFactory(rpc, owner.sk)

  const origination = await Tezos.contract.originate({
    code,
    storage: {
      name: 'InvestaX Preferred Stock',
      symbol: 'IXPS',
      owner: owner.pkh,
      totalSupply: 0,
      ledger: new MichelsonMap(),
      whitelist: new MichelsonMap(),
      admins: new MichelsonMap(),
      lockingList: new MichelsonMap()
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
