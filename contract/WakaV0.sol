// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {IWaka} from "./interface/IWaka.sol";
import {Strings} from "@openzeppelin/utils/Strings.sol";
import {Base64} from "@openzeppelin/utils/Base64.sol";

contract WakaV0 is IWaka {
    /// STRUCTS ///
    
    /// @dev flatBackground, roundBackground, flatBody, roundBody
    struct Unit0 {
        bytes core;
        bytes name;
    }

    /// @dev eyePositions
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
        eyePositions[0] = Unit1({x0: "160", x1: "310", y0: "200", y1: "200", name: ""});
    }

    /// ART ///

    function waka(uint256 _tokenId) external view returns (string memory) {
        uint256 seed = uint256(keccak256(abi.encodePacked(_tokenId)));

        /// @dev Inverted: background round, body flat
        bool isInverted = _getIsInverted(seed);

        Unit0 memory flatBackgroundData = _getFlatBackground(seed);
        Unit0 memory roundBackgroundData = _getRoundBackground(seed);
        Unit0 memory flatBodyData = _getFlatBody(seed);
        Unit0 memory roundBodyData = _getRoundBody(seed);
        Unit1 memory eyePositionData = _getEyePosition(seed);

        /// Setup
        bytes memory svgHTML = abi.encodePacked('<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 500 500" >');

        /// Background and Body
        if (isInverted) {
            svgHTML = abi.encodePacked(svgHTML, '<rect width="500" height="500" x="0" y="0" fill="', flatBackgroundData.core, '"><animate attributeName="fill" values="', roundBackgroundData.core,'" dur="10s" repeatCount="indefinite" /></rect>');
            svgHTML = abi.encodePacked(svgHTML, '<path d="M50,250 C50,0 450,0 450,250 L450,450 C425.72,450 407.61,383.33, 383.33,383.33 C359.05,383.33 340.94,450, 316.66,450 C292.38,450 274.28,383.33 250,383.33 C225.72,383.33 207.61,450 183.33,450 C159.05,450 140.94,383.33 116.66,383.33 C92.38,383.33 74.28,450 50,450 Z" fill="', flatBodyData.core,'" stroke="black" stroke-width="0.4%" />');
        } else {
            svgHTML = abi.encodePacked(svgHTML, '<rect width="500" height="500" x="0" y="0" fill="', flatBackgroundData.core, '" />');
            svgHTML = abi.encodePacked(svgHTML, '<path d="M50,250 C50,0 450,0 450,250 L450,450 C425.72,450 407.61,383.33, 383.33,383.33 C359.05,383.33 340.94,450, 316.66,450 C292.38,450 274.28,383.33 250,383.33 C225.72,383.33 207.61,450 183.33,450 C159.05,450 140.94,383.33 116.66,383.33 C92.38,383.33 74.28,450 50,450 Z" fill="', flatBodyData.core,'" stroke="black" stroke-width="0.4%" ><animate attributeName="fill" values="', roundBodyData.core,'" dur="10s" repeatCount="indefinite" /></path>');
        }

        /// Eye whites
        svgHTML = abi.encodePacked(svgHTML, '<circle cx="175" cy="200" r="50" fill="white" stroke="black" stroke-width="0.4%"/><circle cx="325" cy="200" r="50" fill="white" stroke="black" stroke-width="0.4%"/>');
        /// Eye blues
        svgHTML = abi.encodePacked(svgHTML, '<circle cx="', eyePositionData.x0,'" cy="', eyePositionData.y0,'" r="23" fill="darkblue" stroke="black" stroke-width="0.4%"/><circle cx="', eyePositionData.x1,'" cy="', eyePositionData.y1,'" r="23" fill="darkblue" stroke="black" stroke-width="0.4%"/></svg>');

        /// Metadata
        svgHTML = abi.encodePacked(
            '{"name": "Ghosts #',
            bytes(Strings.toString(_tokenId)), 
            '", "description": "Ghosts in the machine - WAKA WAKA WAKA WAKA", "image": "data:image/svg+xml;base64,', 
            Base64.encode(svgHTML), 
            '"'
        );
        svgHTML = abi.encodePacked(
            svgHTML,
            ', "attributes": [{"trait_type": "Background A", "value": "',
            flatBackgroundData.name,
            '"}, {"trait_type": "Background B", "value": "',
            roundBackgroundData.name,
            '"}, {"trait_type": "Body A", "value": "',
            flatBodyData.name
        );
        svgHTML = abi.encodePacked(
            svgHTML,
            '"}, {"trait_type": "Body B", "value": "',
            roundBodyData.name,
            '"}, {"trait_type": "Eyes", "value": "',
            eyePositionData.name,
            '"}]}'
        );

        return string.concat('data:application/json;base64,', Base64.encode(svgHTML));
    }

    /// GETTERS ///
    
    function _getIsInverted(uint256 _seed) internal pure returns (bool) {
        return ((_seed % 10) == 0) ? true : false;
    }

    function _getFlatBackground(uint256 _seed) internal view returns (Unit0 memory) {
        return flatBackgrounds[_seed % flatBackgrounds.length];
    }

    function _getRoundBackground(uint256 _seed) internal view returns (Unit0 memory) {
        return roundBackgrounds[_seed % roundBackgrounds.length];
    }

    function _getFlatBody(uint256 _seed) internal view returns (Unit0 memory) {
        return flatBodies[_seed % flatBodies.length];
    }

    function _getRoundBody(uint256 _seed) internal view returns (Unit0 memory) {
        return roundBodies[_seed % roundBodies.length];
    }

    function _getEyePosition(uint256 _seed) internal view returns (Unit1 memory) {
        return eyePositions[_seed % eyePositions.length];
    }
}