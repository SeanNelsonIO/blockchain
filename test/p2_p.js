const P2P = artifacts.require("P2P");

/*
 * uncomment accounts to access the test accounts made available by the
 * Ethereum client
 * See docs: https://www.trufflesuite.com/docs/truffle/testing/writing-tests-in-javascript
 */
contract("P2P", function (/* accounts */) {
  it("should assert true", async function () {
    await P2P.deployed();
    return assert.isTrue(true);
  });
});
