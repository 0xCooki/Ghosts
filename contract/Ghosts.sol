// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {ERC404} from "@pandora/ERC404.sol";

contract Ghosts is ERC404 {
    constructor() ERC404("Ghosts", "GHOST", 18) {}

    function tokenURI(uint256 id_) public view override returns (string memory) {
        id_;
        return "";
    }
}