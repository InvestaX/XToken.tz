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
 * Admin contract provides features to have multiple administrators
 * who can collective perform admin-related tasks instead of depending on the owner.
 *
 * It is assumed by default that the owner is more power than admins
 * and therefore cannot be added to or removed from the admin list.
**************************************************************************************)


(*
* Checks if an address is an administrator.
*
* account -> The address to check if present on the admin list.
* s -> Storage
*
* Returns true if the specified account is in-fact an administrator.
*)
function ifAdmin (const account : address; var s : storage) : bool is 
begin
  var admin : bool := False;

  if account = s.owner then block {
    // The owner always has all rights and privileges assigned to the admins.
    admin := True;
  } else block {
    admin := Big_map.mem (account, s.admins);
  }
end with admin


(*
* Adds the specified address to the list of administrators.
*
* account -> The address to add to the administrator list.
* id -> A unique identifier for this admin account.
* s -> Storage
*
* Note that this feature is restricted for admin use only.
*)
function addAdmin(const account : address; const id : string; const s : storage) : storage is
begin
  if not ifAdmin (sender, s) then failwith ("Access is denied"); else skip;
  if ifAdmin (account, s) then failwith ("The specified account is already an admin"); else skip;

  s.admins[account] := id;
end with s

(*
* Removes the specified address from the list of administrators.
* 
* account --> The address to remove from the administrator list.
* s -> Storage
* 
* Note that this feature is restricted for admin use only.
*)
function removeAdmin(const account : address; const s : storage) : storage is
begin
  if not ifAdmin (sender, s) then failwith ("Access is denied"); else skip;
  if not ifAdmin (account, s) then failwith ("The account you specified is not an admin"); else skip;

  remove account from map s.admins;
end with s

(*
* Checks if an address is an administrator.
*
* account -> The address to check if present on the admin list.
*
* Returns true if the specified account is in fact an administrator.
*)
function isAdmin(const account : address; const c : contract(bool); var s : storage) is 
list [transaction (ifAdmin (account, s), 0tz, c)];
