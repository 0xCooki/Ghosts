// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

/// @notice The interface for Ghosts on-chain SVG
interface IWaka {
    function waka(uint256 _tokenId) external view returns (string memory);
}