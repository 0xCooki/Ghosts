pragma solidity 0.8.24;

import "forge-std/Test.sol";
import "forge-std/console.sol";

import {Ghosts} from "../contract/Ghosts.sol";
import {WakaV0} from "../contract/WakaV0.sol";

contract GhostTests is Test {
    uint256 public blastFork;

    address public cooki = address(420);

    WakaV0 public wakaV0;
    Ghosts public ghosts;

    function setUp() public {
        string memory rpcURL = vm.envString("RPC_URL");
        blastFork = vm.createFork(rpcURL);
        vm.selectFork(blastFork);

        wakaV0 = new WakaV0();
        ghosts = new Ghosts(wakaV0);
    }

    function testStuff() public {
        string memory output = ghosts.tokenURI(0);

        console.log(output);
    }
}