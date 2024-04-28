// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {ERC404} from "@pandoraLegacy/ERC404.sol";
import {IBlast} from "./interface/IBlast.sol";
import {IWaka} from "./interface/IWaka.sol";

/// @title Ghosts 
/// @author Cooki
/// @notice WAKA WAKA
contract Ghosts is ERC404 {
    IBlast public constant blast = IBlast(0x4300000000000000000000000000000000000002);
    IWaka public waka;

    constructor(IWaka _waka, address _owner) ERC404("Ghosts", "GHOST", 18, 690, _owner) {
        balanceOf[_owner] = totalSupply;
        whitelist[_owner] = true;
        waka = _waka;
        blast.configureClaimableGas();
    }

    function tokenURI(uint256 id) public view override returns (string memory) {
        return waka.waka(id);
    }

    function setWaka(IWaka _waka) external onlyOwner {
        waka = _waka;
    }

    function claimGas() external onlyOwner {
        blast.claimAllGas(address(this), msg.sender);
    }
}