/* eslint-disable no-unused-expressions */
const faker = require('faker')
const { getConfig } = require('../config')
const XTokenTZ = require('./helpers/token')
const { toUnix, getLedger } = require('./utils')

describe('Digital Security Issuances', () => {
  let security
  let storage
  let config
  let accounts
  const amounts = [12500000, 35000]

  const id = faker.random.uuid()

  before(async () => {
    config = await getConfig()
    accounts = config.accounts
    const { alice } = accounts

    security = await XTokenTZ.originate(alice)
    storage = await security.storage()
  })

  it('must correctly issue digital securities to the specified account', async () => {
    const { alice } = accounts

    const beneficiary = alice.pkh
    const amount = amounts[0]
    const releaseDate = toUnix(new Date())
    const withWhitelist = true

    const operation = await security.methods.issue(beneficiary, id, amount, releaseDate, withWhitelist).send()
    await operation.confirmation(1)

    const [idDiff, releaseDateDiff, amountDiff] = operation.results[0].metadata.operation_result.big_map_diff

    idDiff.value.string.should.equal(id)
    releaseDateDiff.value.int.should.equal(releaseDate)
    amountDiff.value.prim.should.equal('Pair')
    amountDiff.value.args[1].int.should.equal(amount.toString())
  })

  it('must correctly set the total supply', async () => {
    storage = await security.storage()

    storage.totalSupply.should.be.bignumber
    storage.totalSupply.toString().should.equal(amounts[0].toString())
  })

  it('must allow an admin or the owner to create more issuance', async () => {
    const { bob } = accounts

    const beneficiary = bob.pkh
    const releaseDate = toUnix(new Date())
    const withWhitelist = true

    const operation = await security.methods.issue(beneficiary, id, amounts[1], releaseDate, withWhitelist).send()
    await operation.confirmation(1)
  })

  it('must correctly update the total supply', async () => {
    storage = await security.storage()

    const expected = amounts[0] + amounts[1]

    storage.totalSupply.should.be.bignumber
    storage.totalSupply.toString().should.equal(expected.toString())
  })

  it('must correctly report the ledger balances', async () => {
    storage = await security.storage()

    const bob = await getLedger(storage, accounts.bob.pkh)
    const alice = await getLedger(storage, accounts.alice.pkh)

    alice.balance.toString().should.equal(amounts[0].toString())
    bob.balance.toString().should.equal(amounts[1].toString())
  })
})
