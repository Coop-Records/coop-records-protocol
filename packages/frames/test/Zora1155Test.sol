// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "forge-std/Test.sol";

import {ProtocolRewards} from "@zoralabs/protocol-rewards/src/ProtocolRewards.sol";
import {RewardsSettings} from "@zoralabs/protocol-rewards/src/abstract/RewardSplits.sol";
import {UpgradeGate} from "@zoralabs/zora-1155-contracts/src/upgrades/UpgradeGate.sol";
import {CoopCreator1155Impl} from "@zoralabs/zora-1155-contracts/src/nft/CoopCreator1155Impl.sol";
import {Coop1155} from "@zoralabs/zora-1155-contracts/src/proxies/Coop1155.sol";
import {ZoraCreatorFixedPriceSaleStrategy} from
    "@zoralabs/zora-1155-contracts/src/minters/fixed-price/ZoraCreatorFixedPriceSaleStrategy.sol";
import {ICreatorRoyaltiesControl} from "@zoralabs/zora-1155-contracts/src/interfaces/ICreatorRoyaltiesControl.sol";

import {BoostedMinterFactory} from "../src/BoostedMinterFactory.sol";
import {BoostedMinterImpl} from "../src/BoostedMinterImpl.sol";

contract Zora1155Test is Test {
    address internal zora;
    address internal creator;

    UpgradeGate internal upgradeGate;
    ProtocolRewards internal protocolRewards;
    CoopCreator1155Impl internal zora1155Impl;
    CoopCreator1155Impl internal zora1155;
    uint256 internal zora1155TokenId;

    function setUp() public virtual {
        zora = makeAddr("zora");
        creator = makeAddr("creator");

        protocolRewards = new ProtocolRewards();
        upgradeGate = new UpgradeGate();
        upgradeGate.initialize(zora);

        zora1155Impl = new CoopCreator1155Impl(zora, address(upgradeGate), address(protocolRewards));
        zora1155 = CoopCreator1155Impl(payable(address(new Coop1155(address(zora1155Impl)))));
        zora1155.initialize(
            "test",
            "test",
            ICreatorRoyaltiesControl.RoyaltyConfiguration(0, 0, address(0)),
            payable(creator),
            new bytes[](0)
        );

        vm.prank(creator);
        zora1155TokenId = zora1155.setupNewToken("", type(uint256).max);
    }
}
