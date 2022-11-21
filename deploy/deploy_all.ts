import { HardhatRuntimeEnvironment } from 'hardhat/types';
import { DeployFunction } from 'hardhat-deploy/types';
import { BigNumber, ethers } from 'ethers';

const func: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
    const { deployments, getNamedAccounts } = hre;
    const { deploy } = deployments;
    const { deployer } = await getNamedAccounts();

    const addreses = ["0x93993F6915Dbf72C21799A0Dbd85471Ee5B3c372", "0x546874b6fAbDdD1347CF08D35e2c8BedCe30471f", "0x407C12D39b01E50Cf8a25d41fd349743193D082C", "0x23BF95De9F90338F973056351C8Cd2CB78cbe52f"]

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
    const interestSwapInstance = await hre.ethers.getContract(
        "InterestSwap",
        deployer
    );

    // do infinite approval
    const usdcInstance = await hre.ethers.getContract(
        "USDC",
        deployer
    );

    const tx1 = await usdcInstance.approve(interestSwapResult.address, ethers.constants.MaxUint256);
    await tx1.wait()
    // create sample pool
    const dailyPercent = BigNumber.from("200000000000000") // 0.0002 %
    console.log("Daily percent", dailyPercent.toString())

    const maxDuration = BigNumber.from("30000000000000000000");
    const initialTotalLiquidity = BigNumber.from("10000000000000000000000");
    console.log("initialTotalLiquidity", initialTotalLiquidity.toString())

    console.log("Accepted tokens", [stETHResult.address, stNEARResult.address]);

    const tx2 = await interestSwapInstance.createPool([stETHResult.address, stNEARResult.address], dailyPercent, initialTotalLiquidity, maxDuration);

    tx2.wait()

    console.log("InterestSwap Periphery Address", interestSwapPeripheryResult.address)
};
export default func;