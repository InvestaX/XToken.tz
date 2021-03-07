/* eslint-disable no-unused-expressions */

const { getConfig } = require('../config')
const XTokenTZ = require('./helpers/token')

describe('XToken.tz Origination', () => {
  let storage
  let config
  let accounts

  before(async () => {
    config = await getConfig()
    accounts = config.accounts
    const { alice } = accounts

    const contract = await XTokenTZ.originate(alice)
    storage = await contract.storage()
  })

  it('must correctly set the owner account', async () => {
    const { alice } = accounts
    storage.owner.should.equal(alice.pkh)
  })

  it('must correctly set the initial token supply', async () => {
    storage.totalSupply.should.be.bignumber
    storage.totalSupply.toString().should.equal('0')
  })
})
