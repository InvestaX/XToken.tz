/* eslint-disable no-unused-expressions */


const faker = require('faker')
const { getConfig } = require('../config')
const XTokenTZ = require('./helpers/token')

describe("adding accounts to WhiteListing category" ,()=>{

  let storage
  let config
  let accounts

  before(async () => {
    config = await getConfig()
    accounts = config.accounts
    const { alice } = accounts

    security = await XTokenTZ.originate(alice) //adding alice as the owner or admin
    storage = await security.storage()
    let bob_id; 
    let eve;   
    //only added 3 accounts just for understanding 

    it('bob added to the whitelist', async () => {
        //owner or admin can only add the accounts to whitelist security
        const { bob } = accounts
        bob_id = faker.random.uuid()
        let operation = await security.methods.addToWhitelist(bob.pkh, bob_id).send()
        await operation.confirmation(1)
      })

      it('Mallory added to the whitelist', async () => {
        const { mallory } = accounts

        let operation = await security.methods.addToWhitelist(mallory.pkh, faker.random.uuid()).send()
        await operation.confirmation(1)
      })
      it('eve added to the whitelist', async () => {
         eve  = accounts

        let operation = await security.methods.addToWhitelist(eve.pkh, faker.random.uuid()).send()
        await operation.confirmation(1)
      })  
      
      it('Checking if bob is whitelisted or not' , async() =>{
          const { bob } =accounts
            //This function can be called by an investor or admin or owner
        await security.methods.isWhitelisted(bob.pkh ,security,storage) 
          storage.whitelist[bob.pkh].toString().should.equal(bob_id)
      })

      it('Removing eve from whitelist' , async() =>{
          await security.methods.removeFromWhitelist(eve.pkh,storage)
          storage.whitelist.has(eve.pkh).toString().should.equal("false")
      })
})
})