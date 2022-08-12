const { deployments, getNamedAccounts, network } = require("hardhat")
const { verify } = require("../utils/verify")
const { devChain } = require("../helper-hardhat-config")

module.exports = async () => {
    const { deploy, log } = deployments

    const { deployer } = await getNamedAccounts()

    const chainId = network.config.chainId

    const ix = await deploy("IX", {
        from: deployer,
        args: [],
        log: true,
        waitConfirmations: network.config.waitConfirmations || 1,
    })
    if (!devChain.includes(network.name) && process.env.ETHERSCAN_API_KEY) {
        await verify(ix.address, [])
    }
}

module.exports.tags = ["all", "ix"]

// ...
