const { InMemorySigner } = require('@taquito/signer')
const { TezosToolkit } = require('@taquito/taquito')

const getSignerFactory = async (rpc, secret) => {
  const Tezos = new TezosToolkit(rpc)

  await Tezos.setProvider({
    signer: await InMemorySigner.fromSecretKey(secret),
    config: { confirmationPollingIntervalSecond: 5 }
  })

  return Tezos
}

module.exports = { getSignerFactory }
