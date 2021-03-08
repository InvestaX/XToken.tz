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
