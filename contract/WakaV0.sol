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

    Unit0[8] private flatBackgrounds;
    Unit0[6] private roundBackgrounds;
    Unit0[7] private flatBodies;
    Unit0[9] private roundBodies;
    Unit1[10] private eyePositions;
    
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
        flatBackgrounds[0] = Unit0({core: "#EFE3AB", name: ""});
        flatBackgrounds[1] = Unit0({core: "#CB297A", name: ""});
        flatBackgrounds[2] = Unit0({core: "#2974CB", name: ""});
        flatBackgrounds[3] = Unit0({core: "#E47E62", name: ""});
        flatBackgrounds[4] = Unit0({core: "#60D5C6", name: ""});
        flatBackgrounds[5] = Unit0({core: "#F0F061", name: ""});
        flatBackgrounds[6] = Unit0({core: "#35966C", name: ""});
        flatBackgrounds[7] = Unit0({core: "#67665E", name: ""});
    }

    function _initRoundBackgrounds() internal {
        roundBackgrounds[0] = Unit0({core: "#D5D4CF;#363630;#D5D4CF", name: ""});
        roundBackgrounds[1] = Unit0({core: "#1961C2;#0CA983;#0B7F29;#1961C2", name: ""});
        roundBackgrounds[2] = Unit0({core: "#AF1429;#6F14AF;#AF1429", name: ""});
        roundBackgrounds[3] = Unit0({core: "#DA2D44;#DA542D;#E8C70E;#DA2D44", name: ""});
        roundBackgrounds[4] = Unit0({core: "#25B5EA;#2534EA;#8D11BB;#25B5EA", name: ""});
        roundBackgrounds[5] = Unit0({core: "#87F24D;#E6F24D;#87F24D", name: ""});
    }

    function _initFlatBodies() internal {
        flatBodies[0] = Unit0({core: "#2547BC", name: ""});
        flatBodies[1] = Unit0({core: "#DE1D1D", name: ""});
        flatBodies[2] = Unit0({core: "#DE1D9F", name: ""});
        flatBodies[3] = Unit0({core: "#67DA13", name: ""});
        flatBodies[4] = Unit0({core: "#DA5B13", name: ""});
        flatBodies[5] = Unit0({core: "#800AD7", name: ""});
        flatBodies[6] = Unit0({core: "#EAE30B", name: ""});
    }

    function _initRoundBodies() internal {
        roundBodies[0] = Unit0({core: "#E84186;#174EBC;#E84186", name: ""});
        roundBodies[1] = Unit0({core: "#E77D2B;#9129DE;#DE2E29;#E77D2B", name: ""});
        roundBodies[2] = Unit0({core: "#2DC197;#66716E;#0E5E95;#2DC197", name: ""});
        roundBodies[3] = Unit0({core: "#963584;#6B5FCB;#963584", name: ""});
        roundBodies[4] = Unit0({core: "#C80B59;#F07F0F;#F0E60F;#C80B59", name: ""});
        roundBodies[5] = Unit0({core: "#24D318;#6E18D3;#24D318", name: ""});
        roundBodies[6] = Unit0({core: "#18D3C4;#167AAB;#271DA0;#18D3C4", name: ""});
        roundBodies[7] = Unit0({core: "#FFFEFF;#727178;#FFFEFF", name: ""});
        roundBodies[8] = Unit0({core: "#DB31F9;#F931B3;#B86CD7;#DB31F9", name: ""});
    }

    function _initEyePositions() internal {
        eyePositions[0] = Unit1({x0: "175", x1: "325", y0: "200", y1: "200", name: ""});
        eyePositions[1] = Unit1({x0: "160", x1: "310", y0: "200", y1: "200", name: ""});
        eyePositions[2] = Unit1({x0: "190", x1: "310", y0: "200", y1: "200", name: ""});
        eyePositions[3] = Unit1({x0: "190", x1: "340", y0: "200", y1: "200", name: ""});
        eyePositions[4] = Unit1({x0: "175", x1: "325", y0: "185", y1: "185", name: ""});
        eyePositions[5] = Unit1({x0: "175", x1: "325", y0: "215", y1: "215", name: ""});
        eyePositions[6] = Unit1({x0: "190", x1: "310", y0: "215", y1: "215", name: ""});
        eyePositions[7] = Unit1({x0: "190", x1: "340", y0: "215", y1: "215", name: ""});
        eyePositions[8] = Unit1({x0: "190", x1: "340", y0: "185", y1: "185", name: ""});
        eyePositions[9] = Unit1({x0: "160", x1: "310", y0: "185", y1: "185", name: ""});
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
            '"}, {"trait_type": "Inverted", "value": "',
            (isInverted ? "true" : "false"),
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