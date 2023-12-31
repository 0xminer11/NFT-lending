// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Alpha is ERC20, ERC20Burnable, Pausable, Ownable {
    constructor() ERC20("", "Alpha") {
        _mint(address(this), 10000000000 * 10 ** decimals());
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    function _beforeTokenTransfer(address from, address to, uint256 amount)
        internal
        whenNotPaused
        override
    {
        super._beforeTokenTransfer(from, to, amount);
    }


    function BuyTokens() payable external{
        require(msg.value == 1000000000000000000,"Only 1 MATIC will accept");
        address owner = owner();
        payable(owner).transfer(msg.value);
        _transfer(address(this),msg.sender,1000);
    }

}