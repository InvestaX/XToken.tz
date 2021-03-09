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
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
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

