//SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "./dependencies/flux/CLV2V3Interface.sol";
import "./interfaces/IPriceFeed.sol";

contract FluxPriceFeed is IPriceFeed {
    // @dev target digits
    uint256 public constant TARGET_DIGITS = 18;

    // Map of asset price sources (asset => priceFeedSource)
    mapping(address => CLV2V3Interface) private priceFeedSources;

    struct FluxResponse {
        uint80 roundId;
        int256 answer;
        uint256 timestamp;
        bool success;
        uint8 decimals;
    }

    struct Config {
        address asset;
        address source;
    }

    constructor(Config[] memory _config) {
        uint256 numberOfSources = _config.length;

        for (uint256 i = 0; i < numberOfSources; i++) {
            address currentAsset = _config[i].asset;
            address currentSource = _config[i].source;

            require(currentAsset != address(0), "Invalid asset");
            require(currentSource != address(0), "Invalid source");

            priceFeedSources[currentAsset] = CLV2V3Interface(currentSource);
            emit AssetPriceFeedSourceUpdated(currentAsset, currentSource);
        }
    }

    function getAssetPrice(address _asset)
        external
        view
        override
        returns (uint256)
    {
        require(
            address(priceFeedSources[_asset]) != address(0),
            "Asset price feed doesn't exist"
        );
        FluxResponse memory fluxResponse = _getCurrentFluxResponse(_asset);
        uint256 scaledFluxPrice = _scaleFluxPriceByDigits(
            uint256(fluxResponse.answer),
            fluxResponse.decimals
        );
        return scaledFluxPrice;
    }

    // Internal functions
    function _scaleFluxPriceByDigits(uint256 _price, uint256 _answerDigits)
        internal
        pure
        returns (uint256)
    {
        uint256 price;
        if (_answerDigits >= TARGET_DIGITS) {
            price = _price / (10**(_answerDigits - TARGET_DIGITS));
        } else if (_answerDigits < TARGET_DIGITS) {
            price = _price * (10**(TARGET_DIGITS - _answerDigits));
        }
        return price;
    }

    function _getCurrentFluxResponse(address _asset)
        internal
        view
        returns (FluxResponse memory fluxResponse)
    {
        CLV2V3Interface priceAggregator = priceFeedSources[_asset];
        // First, try to get current decimal precision:
        try priceAggregator.decimals() returns (uint8 decimals) {
            // If call to Flux succeeds, record the current decimal precision
            fluxResponse.decimals = decimals;
        } catch {
            // If call to Flux aggregator reverts, return a zero response with success = false
            return fluxResponse;
        }

        // Secondly, try to get latest price data:
        try priceAggregator.latestRoundData() returns (
            uint80 roundId,
            int256 answer,
            uint256, /* startedAt */
            uint256 timestamp,
            uint80 /* answeredInRound */
        ) {
            // If call to Flux succeeds, return the response and success = true
            fluxResponse.roundId = roundId;
            fluxResponse.answer = answer;
            fluxResponse.timestamp = timestamp;
            fluxResponse.success = true;
            return fluxResponse;
        } catch {
            // If call to Flux aggregator reverts, return a zero response with success = false
            return fluxResponse;
        }
    }
}
