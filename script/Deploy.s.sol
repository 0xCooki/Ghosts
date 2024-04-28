pragma solidity 0.8.24;

import "forge-std/Script.sol";

import {Ghosts} from "../contract/Ghosts.sol";
import {WakaV0} from "../contract/WakaV0.sol";

contract Deploy is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast(deployerPrivateKey);

        WakaV0 wakaV0 = new WakaV0();
        Ghosts ghosts = new Ghosts(wakaV0, 0x42e84F0bCe28696cF1D254F93DfDeaeEB6F0D67d);

        ghosts; /// @dev to avoid the unused warning

        vm.stopBroadcast();
    }
}