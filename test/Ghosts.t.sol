pragma solidity 0.8.24;

import "forge-std/Test.sol";
import "forge-std/console.sol";

import {Ghosts} from "../contract/Ghosts.sol";
import {WakaV0} from "../contract/WakaV0.sol";

contract GhostTests is Test {
    uint256 public blastFork;

    address public cooki = address(420);
    address public fragments = address(690);

    WakaV0 public wakaV0;
    Ghosts public ghosts;

    function setUp() public {
        string memory rpcURL = vm.envString("RPC_URL");
        blastFork = vm.createFork(rpcURL);
        vm.selectFork(blastFork);

        wakaV0 = new WakaV0();
        ghosts = new Ghosts(wakaV0, cooki);
    }

    function testInit() public {
        assertEq(address(ghosts.blast()), 0x4300000000000000000000000000000000000002);
        assertEq(address(ghosts.waka()), address(wakaV0));
        assertEq(ghosts.totalSupply(), 690 * 10 ** 18);
        assertEq(ghosts.balanceOf(cooki), 690 * 10 ** 18);
        assertEq(ghosts.whitelist(cooki), true);
    }

    function testTokenURIOutput() public view {
        string memory output = ghosts.tokenURI(1);
        console.log(output);
    }
}