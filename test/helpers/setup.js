const BigNumber = require('bignumber.js')

require('dotenv').config()
require('chai')
  .use(require('chai-as-promised'))
  .use(require('chai-bignumber')(BigNumber))
  .should()

const env = require('../../env.json')

process.env = env
