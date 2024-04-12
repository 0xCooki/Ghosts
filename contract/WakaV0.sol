// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {IWaka} from "./interface/IWaka.sol";
import {Strings} from "@openzeppelin/utils/Strings.sol";
import {Base64} from "@openzeppelin/utils/Base64.sol";

/// ToDo Psychedelia, eyes
contract WakaV0 is IWaka {
    /// VARIABLES ///
    
    /// flatBackground, flatBody
    struct Unit0 {
        bytes core;
        bytes name;
    }

    /// roundBackground, roundBody
    struct Unit1 {
        bytes name;
    }
    
    /// eye positions
    struct Unit2 {
        bytes name;
    }

    Unit0[1] private flatBackgrounds;
    Unit0[1] private flatBodies;
    
    constructor() {
        _init();
    }
    
    /// STORAGE ///

    function _init() internal {
        _initFlatBackgrounds();
        _initFlatBodies();
    }

    function _initFlatBackgrounds() internal {
        flatBackgrounds[0] = Unit0({core: "cornsilk", name: ""});
    }

    function _initFlatBodies() internal {
        flatBodies[0] = Unit0({core: "crimson", name: ""});
    }

    /// ART ///

    function waka(uint256 _tokenId) external view returns (string memory) {
        Unit0 memory backgroundData = _getFlatBackground(_tokenId);

        /// Style
        bytes memory svgHTML = abi.encodePacked('<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 500 500" >');

        /// Background
        svgHTML = abi.encodePacked(svgHTML, '<rect width="500" height="500" x="0" y="0" fill="', backgroundData.core, '" />');
        svgHTML = abi.encodePacked(svgHTML, '<rect width="500" height="500" x="0" y="0" fill="', backgroundData.core, '"><animate attributeName="fill" values="cornsilk;black;cornsilk" dur="10s" repeatCount="indefinite" ></rect>');

        /// Ghost
        /// Body
        svgHTML = abi.encodePacked(svgHTML, '<path d="M50,250 C50,0 450,0 450,250 L450,450 C425.72,450 407.61,383.33, 383.33,383.33 C359.05,383.33 340.94,450, 316.66,450 C292.38,450 274.28,383.33 250,383.33 C225.72,383.33 207.61,450 183.33,450 C159.05,450 140.94,383.33 116.66,383.33 C92.38,383.33 74.28,450 50,450 Z" fill="purple" stroke="black" stroke-width="0.4%" />');
        svgHTML = abi.encodePacked(svgHTML, '<path d="M50,250 C50,0 450,0 450,250 L450,450 C425.72,450 407.61,383.33, 383.33,383.33 C359.05,383.33 340.94,450, 316.66,450 C292.38,450 274.28,383.33 250,383.33 C225.72,383.33 207.61,450 183.33,450 C159.05,450 140.94,383.33 116.66,383.33 C92.38,383.33 74.28,450 50,450 Z" fill="purple" stroke="black" stroke-width="0.4%" ><animate attributeName="fill" values="crimson;purple;crimson" dur="5s" repeatCount="indefinite" /></path>');
        /// Eye whites
        svgHTML = abi.encodePacked(svgHTML, '<circle cx="175" cy="200" r="50" fill="white" stroke="black" stroke-width="0.4%"/><circle cx="325" cy="200" r="50" fill="white" stroke="black" stroke-width="0.4%"/>');
        /// Eye blues
        svgHTML = abi.encodePacked(svgHTML, '<circle cx="160" cy="200" r="24" fill="darkblue" stroke="black" stroke-width="0.4%"/><circle cx="290" cy="200" r="24" fill="darkblue" stroke="black" stroke-width="0.4%"/>');

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
            backgroundData.name,
            '"}]}'
        );

        return string.concat('data:application/json;base64,', Base64.encode(svgHTML));
    }

    /// GETTERS ///
    
    function _getFlatBackground(uint256 _tokenId) internal view returns (Unit0 memory) {
        return flatBackgrounds[_tokenId % flatBackgrounds.length];
    }
}