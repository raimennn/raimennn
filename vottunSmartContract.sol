// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

contract SendMeATip is Ownable {
    event NewTip(address indexed tipper, string name);

    struct Tip {
        address tipper;
        string name;
        uint256 value;
    }

    Tip[] private tips;

    /**
     * @dev Fetches all stored tips.
     * @return An array of Tip structs containing all tips.
     */
    function getTips() public view returns (Tip[] memory) {
        return tips;
    }

    /**
     * @dev Give a tip to the owner in ETH.
     * @param _name Name of the tipper.
     */
    function giveTip(string memory _name) public payable {
        require(msg.value > 0, "Cannot buy coffee for free!");

        tips.push(Tip(msg.sender, _name, msg.value));

        emit NewTip(msg.sender, _name);
    }

    /**
     * @dev Send the entire balance stored in this contract to the owner.
     */
    function withdrawTips() public onlyOwner {
        (bool success, ) = payable(owner()).call{value: address(this).balance}("");
        require(success, "Transfer failed.");
    }
}
