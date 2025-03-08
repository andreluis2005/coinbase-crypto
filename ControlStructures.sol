// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

contract ControlStructures {
    // Erro personalizado para horário fora do expediente
    error AfterHours(uint256 time);

    // Função FizzBuzz
    function fizzBuzz(uint256 _number) public pure returns (string memory) {
        if (_number % 3 == 0 && _number % 5 == 0) {
            return "FizzBuzz";
        } else if (_number % 3 == 0) {
            return "Fizz";
        } else if (_number % 5 == 0) {
            return "Buzz";
        } else {
            return "Splat";
        }
    }

    // Função Do Not Disturb
    function doNotDisturb(uint256 _time) public pure returns (string memory) {
        // Verifica se o horário é inválido
        if (_time >= 2400) {
            revert("Invalid time: must be less than 2400");
        }

        // Verifica se está fora do expediente
        if (_time > 2200 || _time < 800) {
            revert AfterHours(_time);
        }

        // Verifica se está no horário de almoço
        if (_time >= 1200 && _time <= 1259) {
            revert("At lunch!");
        }

        // Determina o período do dia
        if (_time >= 800 && _time <= 1199) {
            return "Morning!";
        } else if (_time >= 1300 && _time <= 1799) {
            return "Afternoon!";
        } else if (_time >= 1800 && _time <= 2200) {
            return "Evening!";
        }

        // Caso padrão (não deve ser alcançado)
        return "Unknown time!";
    }
}