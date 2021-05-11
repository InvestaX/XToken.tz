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
 * This contract provides whitelist features.
**************************************************************************************)

(*
* Checks if an address is in whitelist.
*
* account -> The address to check if present on the whitelist.
* s -> Storage
*
* Returns true if the specified account is whitelisted.
*)
function ifWhitelisted (const account : address; var s : storage) : bool is
Big_map.mem (account, s.whitelist);


(*
* Checks if an address is in whitelist.
*
* account -> The address to check if present on the whitelist.
* s -> Storage
*
* Returns true if the specified account is whitelisted.
*)
function isWhitelisted(const account : address; const contr : contract(bool); var s : storage) is 
list [transaction (ifWhitelisted (account, s), 0tz, contr)];

(*
* Adds the specified account and identifier to the whitelist.
*
* account -> The address to whitelist.
* id -> The account identifier
* s -> Storage
*
* Note that this feature is restricted for admin use only.
*)
function addToWhitelist(const account : address; const id : string; const s : storage): storage is
begin
  if not ifAdmin (sender, s) then failwith ("Only admin allowed"); else skip;
  if ifWhitelisted (account, s) then failwith ("The specified account is already whitelisted"); else skip;

  s.whitelist[account] := id;
end with s

(*
* Removes the specified account from the whitelist.
*
* account -> The address to remove from the whitelist.
* s -> Storage
*
* Note that this feature is restricted for admin use only.
*)
function removeFromWhitelist(const account : address; const s: storage): storage is
begin
  if not ifAdmin (sender, s) then failwith ("Access is denied"); else skip;
  if not ifWhitelisted (account, s) then failwith ("The specified account is not whitelisted"); else skip;

  remove account from map s.whitelist;
end with s

