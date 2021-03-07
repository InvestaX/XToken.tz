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
 * This contract provides transfer-lock functionality.
**************************************************************************************)

(*
* Signifies if specified account is allowed to perform transfers or is not locked.
*
* who -> Specify an account to check against the transfer lock list.
* s -> Storage
*
* Returns true if the specified account is in fact an administrator.
*)
function ifTransferAllowed (const who : address; var s : storage) : bool is 
begin
  var allowed : bool := False;

  case s.lockingList[who] of
  | None -> block {
    allowed := True;
  }
  | Some (releaseDate) -> block {
    if Tezos.now >= releaseDate then block {
      allowed := True;
    } else skip;
  }
  end;

end with allowed
