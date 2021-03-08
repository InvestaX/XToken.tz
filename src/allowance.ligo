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
 * Allowance contract enables a digital security holder to assign spender(s)
 * who can perform token transfers. 
**************************************************************************************)

(*
* Checks if the sender is allowed to spend the supplied amount of digital securities
* from the specified account.
* 
* accountFrom -> The address to spend digital securities from.
* value -> Enter the amount of digital securities to check if allowed.
* s -> Storage
*
* Returns true if the sender is allowed to spend the supplied amount from the provided account.
*)
function isAllowed (const accountFrom : address; const value : nat; var s : storage) : bool is 
  begin
    var allowed: bool := False;
    if sender =/= accountFrom then block {
      // Checking if the sender is allowed to spend in name of accountFrom
      const src: account = get_force(accountFrom, s.ledger);
      const allowanceAmount: nat = get_force(sender, src.allowances);
      allowed := allowanceAmount >= value;
    };
    else allowed := True;
  end with allowed

(*
* Approves an address (or account) to spend the supplied amount of digital securities
* from the sender's account.
* 
* spender -> The address which is approved to transfer digital securities from the sender's account.
* value -> Enter the maximum amount of digital securities approve for spending.
* s -> Storage
*
* Returns true if the sender is allowed to spend the supplied amount from the provided account.
*)
function approve (const spender : address ; const value : nat ; var s : storage) : storage is
 begin
  // If sender is the spender approving is not necessary
  if sender = spender then skip;
  else block {
    const src: account = get_force(sender, s.ledger);
    src.allowances[spender] := value;
    s.ledger[sender] := src; // Not sure if this last step is necessary
  }
 end with s

(*
* Gets the units of digital securities the given spender can spend from the provided account.
* 
* spender -> The address from where the digital securities can be spent.
* spender -> The address who will spend the digital securities.
* s -> Storage
*
* Returns the amount of securities of the `owner` the `spender` can transfer.
*)
function getAllowance (const owner : address ; const spender : address ; const contr : contract(nat) ; var s : storage) : list(operation) is
 begin
  const src: account = get_force(owner, s.ledger);
  const destAllowance: nat = get_force(spender, src.allowances);
 end with list [transaction(destAllowance, 0tz, contr)]
