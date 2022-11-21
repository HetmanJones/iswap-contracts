// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {PRBMathUD60x18} from "./dependencies/prb-math/PRBMathUD60x18.sol";
import {IPriceFeed} from "./interfaces/IPriceFeed.sol";
import {IERC20} from "./interfaces/IERC20.sol";

import {PriceModel} from "./PriceModel.sol";

import "forge-std/console.sol";

contract InterestSwap {
    using PRBMathUD60x18 for uint256;

    IPriceFeed public priceFeed;

    IERC20 public liquidityToken;

    struct Pool {
        address[] acceptedTokens;
        uint256 totalLiquidity;
        PriceModel priceModel;
    }

    struct Route {
        address poolOwner;
        uint256 poolIndex;
    }

    // user => Pool
    mapping(address => Pool[]) private pools;

    // user => pool index => supported asset => bool
    mapping(address => mapping(uint256 => mapping(address => bool)))
        public isAssetSupported;

    // @dev This could be extended to more templates and include validation
    address[] public priceModels;

    event PoolCreated(
        address indexed owner,
        address[] acceptedTokens,
        PriceModel priceModel,
        uint256 totalLiquidity
    );

    constructor(address _priceFeed, address _liquidityToken) {
        priceFeed = IPriceFeed(_priceFeed);
        liquidityToken = IERC20(_liquidityToken);
    }

    function createPool(
        address[] memory _acceptedTokens,
        address _priceModel,
        uint256 _initialLiquidity
    ) external returns (uint256) {
        uint256 totalTokens = _acceptedTokens.length;
        uint256 newPoolIndex = pools[msg.sender].length;

        console.log("totalTokens", totalTokens);
        console.log("newPoolIndex", newPoolIndex);

        pools[msg.sender].push(
            Pool(_acceptedTokens, _initialLiquidity, PriceModel(_priceModel))
        );

        for (uint256 i = 0; i < totalTokens; i++) {
            isAssetSupported[msg.sender][newPoolIndex][
                _acceptedTokens[i]
            ] = true;
        }

        // transfer initial liquidity amount
        liquidityToken.transferFrom(
            msg.sender,
            address(this),
            _initialLiquidity
        );
        return newPoolIndex;
    }

    function quote(
        address _asset,
        uint256 _amount,
        uint256 _daysTerm,
        Route memory route
    )
        public
        view
        returns (
            uint256,
            uint256,
            uint256
        )
    {
        // @dev verify the route supports that asset
        require(
            isAssetSupported[route.poolOwner][route.poolIndex][_asset],
            "Unsupported asset"
        );

        uint256 collateralPrice = priceFeed.getAssetPrice(_asset);
        uint256 collateralValueinUSDC = collateralPrice.mul(_amount);

        Pool storage poolReference = pools[route.poolOwner][route.poolIndex];
        require(
            collateralValueinUSDC <= poolReference.totalLiquidity,
            "Not enough liquidity in the pool"
        );

        uint256 assetPercentageToCharge = poolReference.priceModel.quote(
            _amount,
            _daysTerm
        );

        // asset percentage to charge, amount to be received, collateralPrice
        uint256 amounToBeSent = _amount - assetPercentageToCharge;
        uint256 amounToBeSentInUSDC = (_amount - assetPercentageToCharge).mul(
            collateralPrice
        );

        return (assetPercentageToCharge, amounToBeSent, amounToBeSentInUSDC);
    }

    function swap(
        address _asset,
        uint256 _amount,
        uint256 _daysTerm,
        Route memory route
    ) external returns (uint256) {
        (, , uint256 amounToBeSentInUSDC) = quote(
            _asset,
            _amount,
            _daysTerm,
            route
        );

        // transfer asset to this contract
        IERC20(_asset).transferFrom(msg.sender, address(this), _amount);
        liquidityToken.transfer(msg.sender, amounToBeSentInUSDC);

        pools[route.poolOwner][route.poolIndex]
            .totalLiquidity -= amounToBeSentInUSDC;

        return amounToBeSentInUSDC;
    }

    function createPriceModel(uint256 _dailyFeePercentage)
        external
        returns (address)
    {
        PriceModel newPriceModel = new PriceModel(_dailyFeePercentage);
        priceModels.push(address(newPriceModel));
        return address(newPriceModel);
    }

    function getPool(address _lp, uint256 _index)
        external
        view
        returns (Pool memory)
    {
        return pools[_lp][_index];
    }

    function getUserTotalPools(address _lp) external view returns (uint256) {
        return pools[_lp].length;
    }
}
