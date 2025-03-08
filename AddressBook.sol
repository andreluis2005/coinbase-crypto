// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/access/Ownable.sol";

contract AddressBook is Ownable {
    struct Contact {
        uint id;
        string firstName;
        string lastName;
        uint[] phoneNumbers;
    }

    // Mapeamento para armazenar contatos por ID
    mapping(uint => Contact) private contacts;

    // Array para armazenar IDs de contatos
    uint[] private contactIds;

    // Eventos
    event ContactAdded(uint indexed id, string firstName, string lastName);
    event ContactDeleted(uint indexed id);

    // Erro personalizado
    error ContactNotFound(uint id);

    // Construtor que chama o construtor da Ownable
    constructor(address initialOwner) Ownable(initialOwner) {}

    // Função para adicionar um contato
    function addContact(
        uint _id,
        string memory _firstName,
        string memory _lastName,
        uint[] memory _phoneNumbers
    ) external onlyOwner {
        require(contacts[_id].id == 0, "Contact with this ID already exists");

        contacts[_id] = Contact({
            id: _id,
            firstName: _firstName,
            lastName: _lastName,
            phoneNumbers: _phoneNumbers
        });

        contactIds.push(_id);
        emit ContactAdded(_id, _firstName, _lastName);
    }

    // Função para excluir um contato
    function deleteContact(uint _id) external onlyOwner {
        if (contacts[_id].id == 0) {
            revert ContactNotFound(_id);
        }

        delete contacts[_id];
        emit ContactDeleted(_id);
    }

    // Função para obter um contato
    function getContact(uint _id) external view returns (Contact memory) {
        if (contacts[_id].id == 0) {
            revert ContactNotFound(_id);
        }

        return contacts[_id];
    }

    // Função para obter todos os contatos
    function getAllContacts() external view returns (Contact[] memory) {
        Contact[] memory allContacts = new Contact[](contactIds.length);

        for (uint i = 0; i < contactIds.length; i++) {
            allContacts[i] = contacts[contactIds[i]];
        }

        return allContacts;
    }
}