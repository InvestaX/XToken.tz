/* eslint-disable no-unused-expressions */

const faker = require('faker')
const { getConfig } = require('../config')
const XTokenTZ = require('./helpers/token')
const { toUnix, getWhiteList } = require('./utils')
const assert = require('assert')
const expect = require('chai').expect
describe('Whitelist Functionality', () => {
  let storage
  let config
  let accounts
  let security
  let bobId
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

  it('bob added to the whitelist', async () => {
    // owner or admin can only add the accounts to whitelist security
    const { bob } = accounts
    bobId = faker.random.uuid()
    const operation = await security.methods.addToWhitelist(bob.pkh, bobId).send()
    await operation.confirmation(1)
  })

  it('checking if bob is whitelisted or not', async () => {
    // This function is be called by admin or owner
    const bobWhitelistId = await getWhiteList(storage, accounts.bob.pkh)
    bobWhitelistId.toString().should.equal(bobId.toString())
  })

  it('removing bob from whitelist', async () => {
    // This function can only be called by admin or owner
    const operation = await security.methods.removeFromWhitelist(accounts.bob.pkh).send()
    await operation.confirmation(1)
  })
  it('checking if bob is still whitelisted or not', async () => {
    const bobWhitelistId = await getWhiteList(storage, accounts.bob.pkh)
    expect(bobWhitelistId).to.be.undefined
  })

  it('must fail ,not whitelisted still trying to transfer', async () => {
    try {
      const { alice, bob } = accounts

      const beneficiary = alice.pkh
      const amount = amounts.initial
      const releaseDate = toUnix(new Date())
      const withWhitelist = true

      let operation = await security.methods.issue(beneficiary, id, amount, releaseDate, withWhitelist).send()
      await operation.confirmation(1)

      operation = await security.methods.transfer(alice.pkh, bob.pkh, amounts.transfers[0]).send()
      await operation.confirmation(1)

      throw new Error('Expected an error and didn\'t get one!')
    } catch (err) {
      const expected = 'Not in the whitelist'
      assert.equal(err.message, expected)
    }
  })
})
