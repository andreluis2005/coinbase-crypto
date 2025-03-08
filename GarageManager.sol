// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

contract GarageManager {
    // Struct para representar um carro
    struct Car {
        string make;
        string model;
        string color;
        uint256 numberOfDoors;
    }

    // Mapeamento para armazenar a garagem de cada usuário
    mapping(address => Car[]) public garage;

    // Erro personalizado para índice inválido de carro
    error BadCarIndex(uint256 index);

    // Função para adicionar um carro à garagem do usuário
    function addCar(
        string memory _make,
        string memory _model,
        string memory _color,
        uint256 _numberOfDoors
    ) public {
        // Cria um novo carro
        Car memory newCar = Car({
            make: _make,
            model: _model,
            color: _color,
            numberOfDoors: _numberOfDoors
        });

        // Adiciona o carro à garagem do chamador
        garage[msg.sender].push(newCar);
    }

    // Função para obter todos os carros do chamador
    function getMyCars() public view returns (Car[] memory) {
        return garage[msg.sender];
    }

    // Função para obter todos os carros de um usuário específico
    function getUserCars(address _user) public view returns (Car[] memory) {
        return garage[_user];
    }

    // Função para atualizar um carro na garagem do chamador
    function updateCar(
        uint256 _index,
        string memory _make,
        string memory _model,
        string memory _color,
        uint256 _numberOfDoors
    ) public {
        // Verifica se o índice é válido
        if (_index >= garage[msg.sender].length) {
            revert BadCarIndex(_index);
        }

        // Atualiza o carro no índice especificado
        garage[msg.sender][_index] = Car({
            make: _make,
            model: _model,
            color: _color,
            numberOfDoors: _numberOfDoors
        });
    }

    // Função para redefinir a garagem do chamador
    function resetMyGarage() public {
        delete garage[msg.sender];
    }
}