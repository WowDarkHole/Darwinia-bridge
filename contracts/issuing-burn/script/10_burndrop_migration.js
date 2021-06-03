const DeployAndTest = artifacts.require("./DeployAndTest.sol")
const TokenBurnDrop = artifacts.require("TokenBurnDrop")
const SettingsRegistry = artifacts.require("SettingsRegistry")
const SettingIds = artifacts.require("SettingIds")

module.exports = async (deployer, network) => {
    console.log('Burndrop Bank Test')
    if (network != "development") {
        return
    }

    await deployer.deploy(SettingIds)
    await deployer.deploy(DeployAndTest)
    await deployer.deploy(TokenBurnDrop)
    const settingsRegistry = await deployer.deploy(SettingsRegistry)

    const settingIds = await SettingIds.deployed();
    const deployAndTest = await DeployAndTest.deployed();
    const tokenBurnDrop = await TokenBurnDrop.deployed();

    await settingsRegistry.setAddressProperty(await settingIds.CONTRACT_RING_ERC20_TOKEN.call(), await deployAndTest.testRING.call())
    await settingsRegistry.setAddressProperty(await settingIds.CONTRACT_KTON_ERC20_TOKEN.call(), await deployAndTest.testKTON.call())

    await tokenBurnDrop.initializeContract(settingsRegistry.address)
}
