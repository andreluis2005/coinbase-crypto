// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "./AddressBook.sol";

contract AddressBookFactory {
    // Evento para registrar a criação de um novo AddressBook
    event AddressBookCreated(address indexed owner, address indexed addressBook);

    // Função para implantar um novo AddressBook
    function deploy() external returns (address) {
        AddressBook newAddressBook = new AddressBook(msg.sender); // Passa msg.sender como initialOwner
        emit AddressBookCreated(msg.sender, address(newAddressBook));
        return address(newAddressBook);
    }
}