/* eslint-disable no-unused-expressions */

const faker = require('faker')
const { getConfig } = require('../config')
const XTokenTZ = require('./helpers/token')
const { getWhiteList } = require('./utils')

describe('Whitelist Functionality', () => {
  let storage
  let config
  let accounts
  let security
  let bobId
  
  before(async () => {
      config = await getConfig()
      accounts = config.accounts
      const { alice } = accounts
      security = await XTokenTZ.originate(alice) // adding alice as the owner or admin
      storage = await security.storage()
    })
              
     it('bob added to the whitelist', async () => {
    // owner or admin can only add the accounts to whitelist security
    const { bob } = accounts
    bobId = faker.random.uuid()
    const operation = await security.methods.addToWhitelist(bob.pkh, bobId).send()
    await operation.confirmation(1)
  })

      it('checking if bob is whitelisted or not', async () =>  {
    // This function is be called by admin or owner
    const bobWhitelistId = await getWhiteList(storage, accounts.bob.pkh)
    bobWhitelistId.toString().should.equal(bobId.toString())
  })

      it('removing bob from whitelist', async () =>  {
        //This function can only be called by admin or owner
    await security.methods.removeFromWhitelist(accounts.bob.pkh)
  })
})
