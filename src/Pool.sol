// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {PriceModel} from "./PriceModel.sol";
import {IPriceFeed} from "./interfaces/IPriceFeed.sol";
import {IERC20} from "./interfaces/IERC20.sol";
import {PRBMathUD60x18} from "./dependencies/PRBMathUD60x18.sol";

contract Pool {
    using PRBMathUD60x18 for uint256;

    address[] public acceptedTokens;
    uint256 public totalLiquidity;
    IERC20 public liquidityToken;
    PriceModel public priceModel;
    IPriceFeed public priceFeed;

    mapping(address => bool) public isAssetSupported;

    constructor(
        address[] memory _acceptedTokens,
        address _priceModel,
        address _liquidityTokenAddress,
        address _priceFeed,
        uint256 _initialLiquidity
    ) {
        uint256 totalTokens = _acceptedTokens.length;
        for (uint256 i = 0; i < totalTokens; i++) {
            acceptedTokens.push(_acceptedTokens[i]);
            isAssetSupported[_acceptedTokens[i]] = true;
        }
        totalLiquidity = _initialLiquidity;
        priceModel = PriceModel(_priceModel);

        // transfer initial liquidity amount to this contract
        liquidityToken = IERC20(_liquidityTokenAddress);
        liquidityToken.transferFrom(
            tx.origin, // to think if there is a better way but I don't see any risk since we are not using it for authorization
            address(this),
            _initialLiquidity
        );
        priceFeed = IPriceFeed(_priceFeed);
    }

    function quote(
        address _asset,
        uint256 _amount,
        uint256 _daysTerm
    ) public returns (uint256) {
        require(isAssetSupported[_asset], "Unsupported asset");
        uint256 price = priceModel.quote(_amount, _daysTerm);
        return price;
    }

    function swap(
        address _asset,
        uint256 _amount,
        uint256 _daysTerm
    ) external returns (uint256) {
        // @dev price comes as a percentage of the asset in dollar value
        uint256 percentageOfAmountToPay = quote(_asset, _amount, _daysTerm);
        uint256 price = priceFeed.getAssetPrice(_asset);
        uint256 amountToSwap = price.mul(_amount);

        require(amountToSwap <= totalLiquidity, "Not enough liquidity");

        // @dev amount to transfer would be => amount * price * percentageOfAmountToPay
        uint256 amountOfStablesToPay = _amount.mul(price).mul(
            percentageOfAmountToPay
        );

        // transfer asset to this contract
        IERC20(_asset).transferFrom(msg.sender, address(this), _amount);
        liquidityToken.transfer(msg.sender, amountOfStablesToPay);

        // update total liquidity
        totalLiquidity -= amountToSwap;

        return amountOfStablesToPay;
    }
    // create swapper position.....

    // pending functions
    // recover collateral
    // increase liquidity
}

// en deployment
// create stETH tokens
// transfer to swapper
// create USDC tokens
// give to liquidity provider
// create lending pool factory
// setup price feeds
// done
