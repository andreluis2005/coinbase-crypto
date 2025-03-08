// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

contract EmployeeStorage {
    // Variáveis de estado
    uint256 private shares; // Número de ações do funcionário
    string public name;     // Nome do funcionário
    uint256 private salary; // Salário do funcionário (0 a 1.000.000)
    uint256 public idNumber; // Número de identificação do funcionário

    // Erro personalizado para muitas ações
    error TooManyShares(uint256 totalShares);

    // Construtor
    constructor(uint256 _shares, string memory _name, uint256 _salary, uint256 _idNumber) {
        shares = _shares;
        name = _name;
        salary = _salary;
        idNumber = _idNumber;
    }

    // Função para visualizar o salário
    function viewSalary() public view returns (uint256) {
        return salary;
    }

    // Função para visualizar as ações
    function viewShares() public view returns (uint256) {
        return shares;
    }

    // Função para conceder ações
    function grantShares(uint256 _newShares) public {
        // Verifica se o número de novas ações é válido
        if (_newShares > 5000) {
            revert("Too many shares");
        }

        // Verifica se o total de ações excede 5000
        uint256 totalShares = shares + _newShares;
        if (totalShares > 5000) {
            revert TooManyShares(totalShares);
        }

        // Atualiza o número de ações
        shares = totalShares;
    }

    // Função para verificar o empacotamento de variáveis de armazenamento
    function checkForPacking(uint256 _slot) public view returns (uint256 r) {
        assembly {
            r := sload(_slot)
        }
    }

    // Função para redefinir as ações (apenas para depuração)
    function debugResetShares() public {
        shares = 1000;
    }
}