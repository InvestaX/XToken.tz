(*************************************************************************************
 *
 * InvestaX XToken.tz
 *
 *
 * (c) Copyright 2020 IC SG PTE LTD, all rights reserved.
 * Contract: Admin
 * Authored by: Binod Nirvan
 *
 *
 * No part of this source code may be reproduced, stored in a retrieval system,
 * or transmitted, in any form or by any means, electronic, printing, photocopying,
 * recording, or otherwise, without the prior written permission of IC SG PTE LTD.
 *
 *
 *
 * This contract provides redemption-related functionality.
**************************************************************************************)

(*
* Redeems the digital securities held by the specified account.
* 
* who -> The account to redeem the digital securities from.
* id -> Account id related to the specified account.
* value -> The amount of units to redeem.
* s -> Storage
*
* Note that this feature is restricted for admin use only.
*)
function redeem (const who: address; const id: string; const value : nat ; var s : storage) : storage is
begin
  if not ifAdmin (sender, s) then failwith ("Access is denied"); else skip;

  case s.whitelist[who] of
  | None -> failwith ("Unknown investor") // The address is not whitelisted
  | Some (x) -> block {
    // Wrong id was specified
    if x =/= id then failwith ("Identity/account mismatch"); else skip;
  }
  end;

  var ownerAccount: account := record 
    balance = 0n;
    allowances = (map end : map (address, nat));
  end;

  case s.ledger[s.owner] of
  | None -> skip
  | Some (x) -> ownerAccount := x
  end;

  if value > ownerAccount.balance 
  then failwith ("Insufficient balance");
  else skip;

  ownerAccount.balance := abs (ownerAccount.balance - value);
  s.ledger[s.owner] := ownerAccount;
  s.totalSupply := abs (s.totalSupply - value);
end with s

(*
* Forcefully redeems the digital securities held by the specified account.
* 
* who -> The account to redeem the digital securities from.
* value -> The amount of units to redeem.
* s -> Storage
*
* Note that this feature is restricted for admin use only.
*)
function forceRedeem (const who: address; const value : nat ; var s : storage) : storage is
begin
  if not ifAdmin (sender, s) then failwith ("Access is denied"); else skip;

  var ownerAccount: account := record 
    balance = 0n;
    allowances = (map end : map (address, nat));
  end;

  case s.ledger[s.owner] of
  | None -> skip
  | Some (x) -> ownerAccount := x
  end;

  if value > ownerAccount.balance 
  then failwith ("Insufficient balance");
  else skip;

  ownerAccount.balance := abs (ownerAccount.balance - value);
  s.ledger[s.owner] := ownerAccount;
  s.totalSupply := abs (s.totalSupply - value);
end with s

