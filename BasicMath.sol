// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

contract BasicMath {
    // Função para adição
    function adder(uint256 _a, uint256 _b) public pure returns (uint256 sum, bool error) {
        // Verifica se a adição causa overflow
        unchecked {
            sum = _a + _b;
            if (sum < _a || sum < _b) {
                return (0, true); // Overflow ocorreu
            }
        }
        return (sum, false); // Sem overflow
    }

    // Função para subtração
    function subtractor(uint256 _a, uint256 _b) public pure returns (uint256 difference, bool error) {
        // Verifica se a subtração causa underflow
        if (_b > _a) {
            return (0, true); // Underflow ocorreu
        }
        difference = _a - _b;
        return (difference, false); // Sem underflow
    }
}