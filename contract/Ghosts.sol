// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {ERC404} from "@pandoraLegacy/ERC404.sol";
import {IWaka} from "./IWaka.sol";

/// @title Ghosts
/// @author Cooki
/// @notice Waka waka waka
contract Ghosts is ERC404 {
    IWaka public waka;

    constructor(IWaka _waka) ERC404("Ghosts", "GHOST", 18, 690, msg.sender) {
        balanceOf[msg.sender] = totalSupply;
        waka = _waka;
        /// Blast config
    }

    function tokenURI(uint256 id) public view override returns (string memory) {
        return waka.draw(id);
    }

    function setWaka(IWaka _waka) external onlyOwner {
        waka = _waka;
    }
}