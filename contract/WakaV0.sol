// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {IWaka} from "./interface/IWaka.sol";
import {Strings} from "@openzeppelin/utils/Strings.sol";
import {Base64} from "@openzeppelin/utils/Base64.sol";

contract WakaV0 is IWaka {
    /// STRUCTS ///
    
    /// flatBackground, roundBackground, flatBody, roundBody
    struct Unit0 {
        bytes core;
        bytes name;
    }

    /// eyePositions
    struct Unit1 {
        bytes x0;
        bytes x1;
        bytes y0;
        bytes y1;
        bytes name;
    }

    /// VARIABLES ///

    Unit0[1] private flatBackgrounds;
    Unit0[1] private roundBackgrounds;
    Unit0[1] private flatBodies;
    Unit0[1] private roundBodies;
    Unit1[1] private eyePositions;
    
    constructor() {
        _init();
    }
    
    /// STORAGE ///

    function _init() internal {
        _initFlatBackgrounds();
        _initFlatBodies();
        _initRoundBackgrounds();
        _initRoundBodies();
        _initEyePositions();
    }

    function _initFlatBackgrounds() internal {
        flatBackgrounds[0] = Unit0({core: "cornsilk", name: ""});
    }

    function _initRoundBackgrounds() internal {
        roundBackgrounds[0] = Unit0({core: "cornsilk;black;cornsilk", name: ""});
    }

    function _initFlatBodies() internal {
        flatBodies[0] = Unit0({core: "crimson", name: ""});
    }

    function _initRoundBodies() internal {
        roundBodies[0] = Unit0({core: "crimson;purple;crimson", name: ""});
    }

    function _initEyePositions() internal {
        eyePositions[0] = Unit1({x0: "200", x1: "500", y0: "747", y1: "400", name: ""});
    }

    /// ART ///

    function waka(uint256 _tokenId) external view returns (string memory) {
        Unit0 memory backgroundData = _getFlatBackground(_tokenId);

        bool isInverted = true; /// Inverted: background round, body flat

        /// Setup
        bytes memory svgHTML = abi.encodePacked('<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 500 500" >');

        /// Background
        if (isInverted) {
            svgHTML = abi.encodePacked(svgHTML, '<rect width="500" height="500" x="0" y="0" fill="', backgroundData.core, '"><animate attributeName="fill" values="cornsilk;black;cornsilk" dur="10s" repeatCount="indefinite" /></rect>');
        } else {
            svgHTML = abi.encodePacked(svgHTML, '<rect width="500" height="500" x="0" y="0" fill="', backgroundData.core, '" />');
        }

        /// Ghost
        /// Body
        if (isInverted) {
            svgHTML = abi.encodePacked(svgHTML, '<path d="M50,250 C50,0 450,0 450,250 L450,450 C425.72,450 407.61,383.33, 383.33,383.33 C359.05,383.33 340.94,450, 316.66,450 C292.38,450 274.28,383.33 250,383.33 C225.72,383.33 207.61,450 183.33,450 C159.05,450 140.94,383.33 116.66,383.33 C92.38,383.33 74.28,450 50,450 Z" fill="purple" stroke="black" stroke-width="0.4%" />');
        } else {
            svgHTML = abi.encodePacked(svgHTML, '<path d="M50,250 C50,0 450,0 450,250 L450,450 C425.72,450 407.61,383.33, 383.33,383.33 C359.05,383.33 340.94,450, 316.66,450 C292.38,450 274.28,383.33 250,383.33 C225.72,383.33 207.61,450 183.33,450 C159.05,450 140.94,383.33 116.66,383.33 C92.38,383.33 74.28,450 50,450 Z" fill="purple" stroke="black" stroke-width="0.4%" ><animate attributeName="fill" values="crimson;purple;crimson" dur="10s" repeatCount="indefinite" /></path>');
        }

        /// Eye whites
        svgHTML = abi.encodePacked(svgHTML, '<circle cx="175" cy="200" r="50" fill="white" stroke="black" stroke-width="0.4%"/><circle cx="325" cy="200" r="50" fill="white" stroke="black" stroke-width="0.4%"/>');
        /// Eye blues
        svgHTML = abi.encodePacked(svgHTML, '<circle cx="160" cy="200" r="23" fill="darkblue" stroke="black" stroke-width="0.4%"/><circle cx="310" cy="200" r="23" fill="darkblue" stroke="black" stroke-width="0.4%"/></svg>');

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

    function _getFlatBodies(uint256 _tokenId) internal view returns (Unit0 memory) {
        return flatBodies[_tokenId % flatBodies.length];
    }
}