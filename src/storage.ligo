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
 * All storage variables can be found here.
**************************************************************************************)
type token_info is map(string,bytes)
type token_id is nat

type account is record
  balance : nat;
  allowances: map(address, nat);
end

type storage is record
  owner: address;
  totalSupply: nat;
  ledger: big_map(address, account);
  whitelist: big_map(address, string);
  admins: big_map(address, string);
  lockingList: big_map(address, timestamp);
  metadata : big_map(string, bytes);
  token_metadata:  big_map(nat, michelson_pair(token_id, "token_id", token_info, "token_info"));
end

