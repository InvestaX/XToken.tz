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
 * The balance contract contains functionality related to token transfers
 * with some additional checks and restrictions.
**************************************************************************************)

(*
* Transfers the specified units of digital securities from `accountFrom` to `destination`.
* 
* accountFrom -> The address to transfer digital securities from.
* destination -> The address to transfer digital securities to.
* value -> Enter the amount of digital securities to transfer.
* s -> Storage
*)
function transfer (const accountFrom : address ; const destination : address ; const value : nat ; var s : storage) : storage is
begin  
  // If accountFrom = destination transfer is not necessary
  if accountFrom = destination then skip;
  else block {
    if not ifWhitelisted (destination, s) then failwith ("Not in the whitelist"); else skip;
    if not ifTransferAllowed (accountFrom, s) then failwith ("Transfers are locked"); else skip;
    if not isAllowed (accountFrom, value, s) then failwith ("Sender not allowed to spend token from source"); else skip;

    // Fetch src account
    const src: account = get_force(accountFrom, s.ledger);

    // Check that the accountFrom can spend that much
    if value > src.balance then failwith ("Source balance is too low"); else skip;

    // Update the accountFrom balance
    // Using the abs function to convert int to nat
    src.balance := abs (src.balance - value);

    s.ledger[accountFrom] := src;

    // Fetch dst account or add empty dst account to ledger
    var dst: account := record 
      balance = 0n;
      allowances = (map end : map(address, nat));
    end;

    case s.ledger[destination] of
    | None -> skip
    | Some (n) -> dst := n
    end;

    // Update the destination balance
    dst.balance := dst.balance + value;

    // Decrease the allowance number if necessary
    case src.allowances[sender] of
    | None -> skip
    | Some (dstAllowance) -> src.allowances[sender] := abs (dstAllowance - value)  // ensure non negative
    end;

    s.ledger[accountFrom] := src;
    s.ledger[destination] := dst;
  }
end with s


(*
* Gets the balance of the given account.
*
* accountFrom -> Enter the address of the account to get balance of.
* s -> Storage
*)
function getBalance (const accountFrom : address ; const contr : contract(nat) ; var s : storage) : list(operation) is
 begin
  const src: account = get_force(accountFrom, s.ledger);
 end with list [transaction(src.balance, 0tz, contr)]


(*
* Gets the total supply of this digital security.
*
* s -> Storage
*)
function getTotalSupply (const contr : contract(nat) ; var s : storage) : list(operation) is
  list [transaction(s.totalSupply, 0tz, contr)]