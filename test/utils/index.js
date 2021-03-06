const toUnix = (date) => {
  return (date.getTime() / 1000).toFixed(0)
}

const getLedger = async (storage, account) => {
  return storage.ledger.get(account)
}

const getAdmin = async (storage, account) => {
  return storage.admins.get(account)
}

const getWhiteList = async (storage, account) => {
  return storage.whitelist.get(account)
}

module.exports = { toUnix, getLedger, getAdmin, getWhiteList }
