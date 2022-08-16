const { deployments, ethers, getNamedAccounts } = require("hardhat")
const { devChain } = require("../../helper-hardhat-config")
const { expect, assert } = require("chai")

!devChain.includes(network.name)
    ? describe.skip
    : describe("IX Testing", async () => {
          let ix
          let deployer

          const TOKEN_ID = 1
          const AMOUNT = 10

          beforeEach(async () => {
              // const {deployer} = await getNamedAccounts()
              deployer = (await getNamedAccounts()).deployer

              // run our .js in delpoy folder
              await deployments.fixture(["all"])

              ix = await ethers.getContract("IX", deployer)
          })

          describe("mint function", async () => {
              it("You're not the owner", async () => {
                  const accounts = await ethers.getSigners()
                  const accountZero = accounts[0]
                  const ixNotOwner = await ix.connect(accountZero)

                  await expect(
                      ixNotOwner.mint(accountZero.address, TOKEN_ID, AMOUNT)
                  ).to.be.reverted
              })
          })

          describe("setTokenURI", async () => {
              it("Set token uri", async () => {
                  await ix.setTokenURI(0, "https://")
                  const tokenId = await ix.uri(0)
                  assert.equal(tokenId, "https://")
              })
          })
      })
