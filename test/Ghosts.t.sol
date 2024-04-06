pragma solidity 0.8.24;

import "forge-std/Test.sol";
import "forge-std/console.sol";

import {Ghosts} from "../contract/Ghosts.sol";

contract GhostTests is Test {
    uint256 public blastFork;

    address public cooki = address(420);

    Ghosts public ghosts;

    function setUp() public {
        string memory rpcURL = vm.envString("RPC_URL");
        blastFork = vm.createFork(rpcURL);
        vm.selectFork(blastFork);

        ghosts = new Ghosts();
    }

    function testInit() public {

    }
}