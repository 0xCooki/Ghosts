// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {IWaka} from "./IWaka.sol";
import {Strings} from "@openzeppelin/utils/Strings.sol";
import {Base64} from "@openzeppelin/utils/Base64.sol";

contract WakaV0 is IWaka {
    function draw(uint256 _tokenId) external view returns (string memory) {
        bytes memory background = 'cornsilk';

        /// Style
        bytes memory svgHTML = abi.encodePacked('<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 500 500" >');

        /// Background
        svgHTML = abi.encodePacked(svgHTML, '<rect width="500" height="500" x="0" y="0" fill="', background, '" />');

        /// Ghost
        

        svgHTML = abi.encodePacked(svgHTML, '</svg>');

        /// Metadata
        svgHTML = abi.encodePacked(
            '{"name": "Ghosts #',
            bytes(Strings.toString(_tokenId)), 
            '", "description": "", "image": "data:image/svg+xml;base64,', 
            Base64.encode(svgHTML), 
            '"'
        );
        svgHTML = abi.encodePacked(
            svgHTML,
            ', "attributes": [{"trait_type": "Background", "value": "',
            background,
            '"}]}'
        );

        return string.concat('data:application/json;base64,', Base64.encode(svgHTML));
    }
}