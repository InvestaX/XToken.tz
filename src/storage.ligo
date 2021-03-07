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
 * All storage variables can be found here.
**************************************************************************************)

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
end
