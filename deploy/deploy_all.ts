import { HardhatRuntimeEnvironment } from 'hardhat/types';
import { DeployFunction } from 'hardhat-deploy/types';
import { BigNumber, ethers } from 'ethers';

const func: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
    const { deployments, getNamedAccounts } = hre;
    const { deploy } = deployments;
    const { deployer } = await getNamedAccounts();

    const addreses = ["0x93993F6915Dbf72C21799A0Dbd85471Ee5B3c372", "0x546874b6fAbDdD1347CF08D35e2c8BedCe30471f"]

    const usdcResult = await deploy("USDC", {
        from: deployer,
        log: true,
        args: [addreses],
    });

    const stETHResult = await deploy("stETH", {
        from: deployer,
        log: true,
        args: [addreses],
    });

    const stNEARResult = await deploy("stNEAR", {
        from: deployer,
        log: true,
        args: [addreses],
    });

    const fluxDataFeedForNEAR = "0x0a13BC1F3C441BCB165e8925Fe3E27d18d1Cd66C";
    const fluxDataFeedForETH = "0x842AF8074Fa41583E3720821cF1435049cf93565";

    const configs = [[stETHResult.address, fluxDataFeedForETH], [stNEARResult.address, fluxDataFeedForNEAR]];

    const priceFeedResult = await deploy("FluxPriceFeed", {
        from: deployer,
        log: true,
        args: [configs],
    });

    // deploy main contract
    const interestSwapResult = await deploy("InterestSwap", {
        from: deployer,
        log: true,
        args: [priceFeedResult.address, usdcResult.address],
    });

    const interestSwapPeripheryResult = await deploy("InterestSwapPeriphery", {
        from: deployer,
        log: true,
        args: [interestSwapResult.address],
    });

    // create price model
    const interestSwapInstance = await hre.ethers.getContractAt(
        "InterestSwap",
        interestSwapResult.address
    );

    const dailyPercent = BigNumber.from(0.0002 * 10 ** 18);
    await interestSwapInstance.createPriceModel(dailyPercent);

    // do infinite approval
    const usdcInstance = await hre.ethers.getContractAt(
        "USDC",
        usdcResult.address
    );

    usdcInstance.approve(interestSwapInstance.address, ethers.constants.MaxUint256);

    console.log("InterestSwap Periphery Address", interestSwapPeripheryResult.address)
};
export default func;