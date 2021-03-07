const path = require('path')
const fs = require('fs').promises
const accounts = require('./accounts.json')

const getConfig = async () => {
  const { RPC } = process.env
  const file = await fs.readFile(path.join(process.cwd(), 'build', 'XToken.tz'))

  return {
    rpc: RPC,
    accounts,
    code: file.toString()
  }
}

module.exports = { getConfig }
