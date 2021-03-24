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
 * The token contract contains functionality related to token details
**************************************************************************************)

(*
* Gets the token symbol of this digital security.
*
* s -> Storage
*)
function getSymbol (const contr : contract(string) ; var s : storage) : list(operation) is
 list [transaction(s.symbol, 0tz, contr)]

(*
* Gets the token name of this digital security.
*
* s -> Storage
*)
function getName (const contr : contract(string) ; var s : storage) : list(operation) is
  list [transaction(s.name, 0tz, contr)]
