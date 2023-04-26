// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract P2P {
    struct Prosumer {
        address id;
        uint energyStatus;
        uint balance;
    }

    mapping(address => Prosumer) public prosumers;

    // constructor() public {}
    function registerProsumer(address id) public {
        Prosumer memory newProsumer = Prosumer(id, 0, 0);
        // prosumers[] = newProsumer;
        prosumers[id] = newProsumer;
    }

    function buyEnergy(
        address buyerId,
        address sellerId,
        uint energyAmount
    ) public payable {
        require(prosumers[buyerId].balance >= msg.value, "Insufficient funds");
        prosumers[buyerId].balance -= msg.value;
        prosumers[sellerId].balance += msg.value;
        prosumers[buyerId].energyStatus += energyAmount;
        prosumers[sellerId].energyStatus -= energyAmount;
    }

    function sellEnergy(
        address sellerId,
        address buyerId,
        uint energyAmount,
        uint price
    ) public {
        require(
            prosumers[sellerId].energyStatus >= energyAmount,
            "Insufficient energy to sell"
        );
        prosumers[sellerId].energyStatus -= energyAmount;
        prosumers[buyerId].energyStatus += energyAmount;
        prosumers[sellerId].balance += price;
        prosumers[buyerId].balance -= price;
    }

    function getInstructorInfos(
        address prosumerId
    ) public view returns (address, uint, uint) {
        return (
            prosumers[prosumerId].id,
            prosumers[prosumerId].energyStatus,
            prosumers[prosumerId].balance
        );
    }
}
