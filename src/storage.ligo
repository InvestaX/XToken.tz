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

type account is record
  balance : nat;
  allowances: map(address, nat);
end

 
//type token_metadata1 is big_map(nat, (nat * map (string, bytes)));


// type token_metadata_record is record [
//     token_id : nat;
//     token_info : map(string , bytes) ;
// ]

type storage is record
  owner: address;
  totalSupply: nat;
  ledger: big_map(address, account);
  whitelist: big_map(address, string);
  admins: big_map(address, string);
  lockingList: big_map(address, timestamp);
  metadata : big_map(string, bytes);
  token_metadata : big_map(nat,(nat * map(string,bytes)));
end



//  token_metadata = Big_map.literal [          (0n, {
//                                                     token_id = 0n; 
//                                                     token_info = Map.literal[
                                                      
//                                                       ("token 0 gros", 0x7070);
//                                                       ("token 0 encore", 0x8170)
//                                                       ]
//                                                   });
//                                              (1n, 
//                                              {
//                                                token_id = 1n; 
//                                                token_info = Map.literal[(
//                                                  "token 1 fieu", 0x4242)]
//                                              })
//      ]  }