// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

// Contrato base abstrato para funcionários
abstract contract Employee {
    // Variáveis públicas
    uint256 public idNumber;
    uint256 public managerId;

    // Construtor
    constructor(uint256 _idNumber, uint256 _managerId) {
        idNumber = _idNumber;
        managerId = _managerId;
    }

    // Função virtual para calcular o custo anual
    function getAnnualCost() public view virtual returns (uint256);
}

// Contrato para funcionários assalariados
contract Salaried is Employee {
    // Variável pública para salário anual
    uint256 public annualSalary;

    // Construtor
    constructor(
        uint256 _idNumber,
        uint256 _managerId,
        uint256 _annualSalary
    ) Employee(_idNumber, _managerId) {
        annualSalary = _annualSalary;
    }

    // Implementação da função getAnnualCost
    function getAnnualCost() public view override returns (uint256) {
        return annualSalary;
    }
}

// Contrato para funcionários horistas
contract Hourly is Employee {
    // Variável pública para taxa horária
    uint256 public hourlyRate;

    // Construtor
    constructor(
        uint256 _idNumber,
        uint256 _managerId,
        uint256 _hourlyRate
    ) Employee(_idNumber, _managerId) {
        hourlyRate = _hourlyRate;
    }

    // Implementação da função getAnnualCost
    function getAnnualCost() public view override returns (uint256) {
        return hourlyRate * 2080; // 2080 horas por ano
    }
}

// Contrato para gerentes
contract Manager {
    // Array público para armazenar IDs dos subordinados
    uint256[] public employeeIds;

    // Função para adicionar um subordinado
    function addReport(uint256 _employeeId) public {
        employeeIds.push(_employeeId);
    }

    // Função para redefinir a lista de subordinados
    function resetReports() public {
        delete employeeIds;
    }
}

// Contrato para vendedores (herda de Hourly)
contract Salesperson is Hourly {
    // Construtor
    constructor(
        uint256 _idNumber,
        uint256 _managerId,
        uint256 _hourlyRate
    ) Hourly(_idNumber, _managerId, _hourlyRate) {}
}

// Contrato para gerentes de engenharia (herda de Salaried e Manager)
contract EngineeringManager is Salaried, Manager {
    // Construtor
    constructor(
        uint256 _idNumber,
        uint256 _managerId,
        uint256 _annualSalary
    ) Salaried(_idNumber, _managerId, _annualSalary) {}
}

// Contrato para submissão (deploy dos contratos Salesperson e EngineeringManager)
contract InheritanceSubmission {
    address public salesPerson;
    address public engineeringManager;

    constructor(address _salesPerson, address _engineeringManager) {
        salesPerson = _salesPerson;
        engineeringManager = _engineeringManager;
    }
}