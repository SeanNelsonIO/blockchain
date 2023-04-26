// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "./P2P.sol";

contract Main {
    P2P private p2p;
    address payable private owner;

    constructor(address p2pAddress) {
        p2p = P2P(p2pAddress);
        owner = payable(msg.sender);
    }

    modifier isProsumerRegistered(address id) {
        require(p2p.prosumers[id].id == id, "Prosumer not registered");
        _;
    }

    modifier hasSufficientFunds(address id, uint requiredAmount) {
        require(
            p2p.prosumers[id].balance >= requiredAmount,
            "Insufficient funds"
        );
        _;
    }

    function registerProsumer(address id, uint energyStatus) public payable {
        P2P.Prosumer memory newProsumer = P2P.Prosumer(
            id,
            energyStatus,
            msg.value
        );
        p2p.prosumers[id] = newProsumer;
    }

    function depositEther(address id) public payable isProsumerRegistered(id) {
        p2p.prosumers[id].balance += msg.value;
    }

    function acceptRequest(
        address id,
        uint energyAmount
    ) public isProsumerRegistered(id) {
        p2p.prosumers[id].energyStatus += energyAmount;
    }

    function getEnergyStatus(
        address id
    ) public view isProsumerRegistered(id) returns (uint) {
        return p2p.prosumers[id].energyStatus;
    }

    function getBalance(
        address id
    ) public view isProsumerRegistered(id) returns (uint) {
        return p2p.prosumers[id].balance;
    }

    function withdrawEther(
        address id,
        uint amount
    ) public isProsumerRegistered(id) hasSufficientFunds(id, amount) {
        p2p.prosumers[id].balance -= amount;
        payable(id).transfer(amount);
    }
}
