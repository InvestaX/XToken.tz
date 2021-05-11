#include "storage.ligo"
#include "transfer-lock.ligo"
#include "admin.ligo"
#include "whitelist.ligo"
#include "allowance.ligo"
#include "balance.ligo"
#include "issuance.ligo"
#include "redemption.ligo"

type transfer_params is michelson_pair(address, "from", michelson_pair(address, "to", nat, "value"), "")
type approve_params is michelson_pair(address, "spender", nat, "value")
type balance_params is michelson_pair(address, "owner", contract(nat), "")
type allowance_params is michelson_pair(michelson_pair(address, "owner", address, "spender"), "", contract(nat), "")  

type action is
| Transfer of transfer_params
| Approve of approve_params
| GetAllowance of allowance_params
| GetBalance of balance_params
| Issue of (address * string * nat * timestamp * bool)
| Redeem of (address * string * nat)
| ForceRedeem of (nat)
| GetTotalSupply of (unit * contract(nat))
| IsWhitelisted of (address * contract(bool))
| AddToWhitelist of (address * string)
| RemoveFromWhitelist of (address)
| IsAdmin of (address * contract(bool))
| AddAdmin of (address * string)
| RemoveAdmin of (address)

function main (const p : action ; const s : storage) : (list(operation) * storage) is
block {
    if amount =/= 0tz then failwith ("Not accepted"); else skip;
  } with case p of
  | Transfer(n) -> ((nil : list(operation)), transfer(n.0, n.1.0, n.1.1, s))
  | Approve(n) -> ((nil : list(operation)), approve(n.0, n.1, s))
  | GetAllowance(n) -> (getAllowance(n.0.0, n.0.1, n.1, s), s)
  | GetBalance(n) -> (getBalance(n.0, n.1, s), s)
  | IsWhitelisted(n) -> (isWhitelisted(n.0, n.1, s), s)
  | AddToWhitelist(n) -> ((nil : list(operation)), addToWhitelist(n.0, n.1, s))
  | RemoveFromWhitelist(n) -> ((nil : list(operation)), removeFromWhitelist(n, s))
  | IsAdmin(n) -> (isAdmin(n.0, n.1, s), s)
  | AddAdmin(n) -> ((nil : list(operation)), addAdmin(n.0, n.1, s))
  | RemoveAdmin(n) -> ((nil : list(operation)), removeAdmin(n, s))
  | GetTotalSupply(n) -> (getTotalSupply(n.1, s), s)
  | Issue(n) -> ((nil : list(operation)), issue(n.0, n.1, n.2, n.3, n.4, s))
  | Redeem(n) -> ((nil : list(operation)), redeem(n.0, n.1, n.2, s))
  | ForceRedeem(n) -> ((nil : list(operation)), forceRedeem( n, s))
end
