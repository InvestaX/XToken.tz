/* eslint-disable no-unused-expressions */
const faker = require('faker')
const { getConfig } = require('../config')
const XTokenTZ = require('./helpers/token')
const { toUnix, getLedger } = require('./utils')

describe('Digital Security Transfers', () => {
  let security
  let storage
  let config
  let accounts
  const amounts = {
    initial: 50000000,
    transfers: [30000, 1000]
  }
  const id = faker.random.uuid()

  before(async () => {
    config = await getConfig()
    accounts = config.accounts
    const { alice } = accounts

    security = await XTokenTZ.originate(alice)
    storage = await security.storage()
  })

  it('must allow Alice to transfer to Bob', async () => {
    const { alice, bob } = accounts

    const beneficiary = alice.pkh
    const amount = amounts.initial
    const releaseDate = toUnix(new Date())
    const withWhitelist = true

    let operation = await security.methods.issue(beneficiary, id, amount, releaseDate, withWhitelist).send()
    await operation.confirmation(1)

    // This will fail
    // -----
    // Todo: write unit test for this
    // operation = await security.methods.transfer(from, to, amounts.transfers[0]).send()
    // await operation.confirmation(1)

    operation = await security.methods.addToWhitelist(bob.pkh, faker.random.uuid()).send()
    await operation.confirmation(1)

    operation = await security.methods.transfer(alice.pkh, bob.pkh, amounts.transfers[0]).send()
    await operation.confirmation(1)
  })

  it('must correctly report the ledger balances', async () => {
    storage = await security.storage()

    const bob = await getLedger(storage, accounts.bob.pkh)
    const alice = await getLedger(storage, accounts.alice.pkh)

    let expected = amounts.initial - amounts.transfers[0]
    alice.balance.toString().should.equal(expected.toString())

    expected = amounts.transfers[0]
    bob.balance.toString().should.equal(expected.toString())
  })

  it('must allow Bob to transfer to Mallory', async () => {
    const { bob, mallory } = accounts

    let operation = await security.methods.addToWhitelist(mallory.pkh, faker.random.uuid()).send()
    await operation.confirmation(1)

    const token = await XTokenTZ.at(security.address, bob)
    operation = await token.methods.transfer(bob.pkh, mallory.pkh, amounts.transfers[1]).send()
    await operation.confirmation(1)
  })

  it('must correctly report the ledger balances again', async () => {
    storage = await security.storage()

    const alice = await getLedger(storage, accounts.alice.pkh)
    const bob = await getLedger(storage, accounts.bob.pkh)
    const mallory = await getLedger(storage, accounts.mallory.pkh)

    let expected = amounts.initial - amounts.transfers[0]
    alice.balance.toString().should.equal(expected.toString())

    expected = amounts.transfers[0] - amounts.transfers[1]
    bob.balance.toString().should.equal(expected.toString())

    expected = amounts.transfers[1]
    mallory.balance.toString().should.equal(expected.toString())
  })
})
