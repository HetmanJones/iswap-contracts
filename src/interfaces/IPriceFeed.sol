// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

/**
 * @dev Interface for protocol price feeds.
 */
interface IPriceFeed {
    /*~~~ EVENT ~~~*/

    /**
     * @dev Emitted after the price source of an asset is updated.
     *
     * @param asset The address of the asset.
     * @param source The price feed source of the asset.
     */
    event AssetPriceFeedSourceUpdated(
        address indexed asset,
        address indexed source
    );

    /*~~~ MAIN LOGIC FUNCTIONS ~~~*/

    /**
     * @dev Used to retrieve a given asset's price.
     *
     * @param _asset Address of the asset.
     * @return uint256 Price of the asset.
     */
    function getAssetPrice(address _asset) external view returns (uint256);
}
