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
* account -> The account identifier
* s -> Storage
*
* Note that this feature is restricted for admin use only.
*)
function addToWhitelist(const account : address; const id : string; const s : storage): storage is
begin
  if not ifAdmin (sender, s) then failwith ("Access is denied"); else skip;
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

