// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract SmartContract {
    address public owner;
    uint256 public productCount;
    AggregatorV3Interface public priceFeed;

    mapping(uint256 => Product) public products;

    constructor() public{
        owner = msg.sender;
    }

    // constructor(address _priceFeed) public {
    //     priceFeed = AggregatorV3Interface(_priceFeed);
    //     owner = msg.sender;
    // }

    // // Retrieves and returns the current ETH/USD price
    // function getPrice() public view returns (uint256) {
    //     (, int256 answer, , , ) = priceFeed.latestRoundData();
    //     return uint256(answer * 10000000000);
    // }

    // // Calculates and returns the equivalent USD value for a specified amount of Ether
    // function getConversionRate(uint256 ethAmount) public view returns (uint256) {
    //     uint256 ethPrice = getPrice();
    //     uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1000000000000000000;
    //     return ethAmountInUsd;
    // }

    struct Product {
        uint256 id;
        string name;
        uint256 price;
        uint256 stock;
    }

    // To provide a history of certain actions that occured in the contract
    event ProductPurchased(address indexed buyer, uint256 indexed productId, uint256 quantity, uint256 totalAmount);

    function addProduct(string memory name, uint256 price, uint256 stock) public onlyOwner {
        productCount++;
        products[productCount] = Product(productCount, name, price, stock);
    }

    function purchaseProduct(uint256 productId, uint256 quantity) public payable {
        require(productId > 0 && productId <= productCount, "Invalid product ID");
        require(quantity > 0 && quantity <= products[productId].stock, "Invalid quantity or insufficient stock");
        uint256 totalAmount = products[productId].price * quantity;
        require(msg.value >= totalAmount, "Insufficient Ether sent");

        // Transfer Ether to owner
        payable(owner).transfer(totalAmount);

        // Update product stock
        products[productId].stock -= quantity;

        // Emit event
        emit ProductPurchased(msg.sender, productId, quantity, totalAmount);

        // Refund excess Ether
        if (msg.value > totalAmount) {
            payable(msg.sender).transfer(msg.value - totalAmount);
        }
    }

    // Withdraw accumulated Ether balance by the owner
    function withdrawBalance() public onlyOwner {
        payable(owner).transfer(address(this).balance);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function.");
        _;
    }

}