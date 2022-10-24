// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.6;

/*
Requirements:

В системе должна храниться информация о различных объектах недвижимости, а именно:
- владелец (аккаунт в сети Ethereum)
- физический адрес
- площадь объекта
- наличие обременений

В системе должен присутствовать администратор, один из аккаунтов сети - автор смарт-контракта.
При старте системы в ней должен присутствовать объект недвижимости:
- Таганрог, ул. Чехова, дом 2, общей площадью 1000 кв.м, без обременений, владелец - произвольный из списка аккаунтов.

Функционал системы:
- добавление объекта недвижимости (только админом)
- изменение владельца (только админом)
- изменение площади (только админом)
- наложение обременений (только админом)
- создание сущности "подарка" - владелец создает с указанием кому подарить, при подтверждении получения сменяется собственник
- создание сущности "продажа" с заявленной стоимостью - владелец выставляет на продажу, покупатель откликается, 
- при успешном переводе средств сменяется собственник, объявление становится неактуальнымдарить и продавать собственность с обременением нельзя
*/

contract Agency {
    address internal admin;

    constructor() {
        admin = msg.sender;
        RealEstateModel storage newNewRealEstate = realEstate[1];
        newNewRealEstate.owner = msg.sender;
        newNewRealEstate.location = "Taganrog city, Chehova street 2";
        newNewRealEstate.square = 1000;
        newNewRealEstate.restrictions = false;
        newNewRealEstate.valid = true;
    }

    receive() external payable {}
    fallback() external payable {}

    function getBalance() public view returns (uint) {
        return address(this).balance;
    }

    struct RealEstateModel {
        address owner;
        string location;
        uint256 square;
        bool restrictions;
        bool valid;
    }

    struct PresentModel {
        uint256 estateId;
        address to;
        bool accepted;
    }

    struct OnSaleModel {
        uint256 estateId;
        address seller;
        uint256 price;
        bool isSold;
    }

    mapping(uint256 => RealEstateModel) realEstate;
    uint256[] realEstateIds;
    mapping(uint256 => PresentModel) presents;
    uint256[] presentEstateIds;
    mapping(uint256 => OnSaleModel) onSaleAds;
    uint256[] onSaleIds;

    function compareStrings(string memory a, string memory b) private view returns (bool) {
        return (keccak256(abi.encodePacked((a))) == keccak256(abi.encodePacked((b))));
    }

    function isAdmin() private view returns (bool) {
        return msg.sender == admin;
    }

    function validateAdminActions (uint id) 
            private view returns (bool, string memory) {

        RealEstateModel storage obj = realEstate[id];
        if(msg.sender != admin) return (false, "Denied! You are not an admin!");
        if(!obj.valid) return (false, "Real Estate doesn't exist");

        return (true, '');
    }

    function validateUsersActions (uint256 id) private view returns (bool, string memory) {
        RealEstateModel storage obj = realEstate[id];
        if (!obj.valid) return (false, "Real Estate doesn't exist");
        if (msg.sender != obj.owner) return (false, "You are not allowed to perform this action!");
        if (obj.restrictions) return (false, "This property is restricted");
        
        return (true, "");
    }

    function validateIfEstateIsAccessible (uint256 id) private 
            view returns (bool, string memory) {
        RealEstateModel storage estate = realEstate[id];
        if (!estate.valid) return (false, "Real Estate doesn't exist");
        if (estate.restrictions) return (false, "This property is restricted");

        return (true, '');
    }

    function registerRealEstate(address owner, string memory location, 
            uint256 square, bool restrictions, uint256 id) public {
        
        require(isAdmin(), "Denied! You are not an admin!");

        RealEstateModel storage newNewRealEstate = realEstate[id];
        newNewRealEstate.owner = owner;
        newNewRealEstate.location = location;
        newNewRealEstate.square = square;
        newNewRealEstate.restrictions = restrictions;
        newNewRealEstate.valid = true;
    }
    
    function getRealEstate(uint256 id) 
        public view returns (address, string memory, 
            uint256, bool) {
        require(bytes(realEstate[id].location).length != 0, "Real Estate doesn't exist");

        return (realEstate[id].owner, realEstate[id].location, 
        realEstate[id].square, realEstate[id].restrictions);
    }

    function changeOwner (uint256 id, address owner) public {
        (bool success, string memory message) = validateAdminActions(id);
        require(success, message);

        if (owner != address(0)) realEstate[id].owner = owner;
    }

    function changeSquare (uint256 id, uint256 square) public {
        (bool success, string memory message) = validateAdminActions(id);
        require(success, message);

        if (square != 0) realEstate[id].square = square;
    }

    function changeRestrictions (uint256 id) public {
      (bool success, string memory message) = validateAdminActions(id);
        require(success, message);

        realEstate[id].restrictions = !realEstate[id].restrictions;
    }

    function presentRealEstate (uint256 id, address recepient) public {
        (bool success, string memory message) = validateUsersActions(id);
        require(success, message);
        
        PresentModel storage newPresent = presents[id];  
        newPresent.estateId = id;
        newPresent.to = recepient;
        newPresent.accepted = false;
    }

    function acceptPresent (uint256 presentId) public {
        PresentModel storage present = presents[presentId];
        RealEstateModel storage estate = realEstate[presentId];
        require(estate.valid, "Real Estate doesn't exist");
        require(!present.accepted, "Present already accepted by user!");
        require(present.to != msg.sender, "You are not allowed to perform this action!");
        require(!estate.restrictions, "This property is restricted");

        estate.owner = msg.sender;
        present.accepted = true;
    }

    function checkPresent (uint256 id) public view returns (uint256, address, bool) {
        return (presents[id].estateId, presents[id].to, presents[id].accepted);
    }

   function sellRealEstate (uint256 id, uint256 price) public {
        (bool success, string memory message) = validateUsersActions(id);
        require(success, message);
        
        OnSaleModel storage newOnSaleAd = onSaleAds[id];  
        newOnSaleAd.estateId = id;
        newOnSaleAd.seller = msg.sender;
        newOnSaleAd.price = price;
        newOnSaleAd.isSold = false;
    }

    function buyRealEstate (uint256 estateId) public payable {
        OnSaleModel storage onSaleEstate = onSaleAds[estateId];
        RealEstateModel storage estate = realEstate[estateId];
        require(estate.valid, "Real Estate doesn't exist");
        require(!onSaleEstate.isSold, "Real Estate already sold!");
        require(!estate.restrictions, "This property is restricted");
        require(msg.value != onSaleEstate.price, "Wrong amount of money");

        require(address(msg.sender).balance >= onSaleEstate.price, "Insufficient funds");

        (bool success, ) = onSaleAds[estateId].seller.call{value: onSaleAds[estateId].price}("");
        require(success, "Transfer failed");
        // payable(onSaleEstate.seller).transfer(onSaleEstate.price);

        estate.owner = msg.sender;
        onSaleEstate.isSold = true;
    }

    function checkSellAd (uint256 id) public view returns (uint256, address, uint256, bool) {
        return (onSaleAds[id].estateId, onSaleAds[id].seller, onSaleAds[id].price, onSaleAds[id].isSold);
    }
}
