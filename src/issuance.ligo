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
 * This contract provides issuance-related functionality.
**************************************************************************************)

(*
* Issues the given units of digital securities to the specified account.
* 
* who -> The address to issue digital securities to.
* id -> Account id related to the specified account.
* value -> Enter the amount of digital securities to issue.
* releaseDate -> The date from when tokens transfers can happen. Enter 0 (zero) if you wish to not lock this account for transfers.
* withWhitelist -> If set to true, the given address will be added to the whitelist before issuance.
* s -> Storage
*
* Note that this feature is restricted for admin use only.
*)
function issue (const who : address; const id : string ; const value : nat ; const releaseDate : timestamp ; const withWhitelist : bool; var s : storage) : storage is
begin
  if not ifAdmin (sender, s) then failwith ("Only admin allowed"); else skip;

  if withWhitelist then block {
    s.whitelist[who] := id;
  } else block {
    case s.whitelist[who] of
    | None -> failwith ("Unknown investor") // The address is not whitelisted
    | Some (x) -> block {
      // Wrong id was specified
      if x =/= id then failwith ("Identity/account mismatch"); else skip;
    }
    end;
  };

  var beneficiary: account := record 
    balance = 0n;
    allowances = (map end : map (address, nat));
  end;

  case s.ledger[who] of
  | None -> skip
  | Some (n) -> beneficiary := n
  end;

  beneficiary.balance := beneficiary.balance + value;

  s.ledger[who] := beneficiary;
  s.totalSupply := s.totalSupply + value;
  s.lockingList[who] := releaseDate;
end with s
