// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

contract ArraysExercise {
    // Array de números inicializado com valores de 1 a 10
    uint[] public numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

    // Array para armazenar endereços dos chamadores
    address[] public senders;

    // Array para armazenar timestamps
    uint[] public timestamps;

    // Função para retornar o array completo de números
    function getNumbers() public view returns (uint[] memory) {
        return numbers;
    }

    // Função para redefinir o array de números para os valores iniciais
    function resetNumbers() public {
        // Redefine o array sem usar .push()
        numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
    }

    // Função para adicionar um array ao array de números existente
    function appendToNumbers(uint[] calldata _toAppend) public {
        for (uint i = 0; i < _toAppend.length; i++) {
            numbers.push(_toAppend[i]);
        }
    }

    // Função para salvar o timestamp e o endereço do chamador
    function saveTimestamp(uint _unixTimestamp) public {
        senders.push(msg.sender);
        timestamps.push(_unixTimestamp);
    }

    // Função para filtrar timestamps após 1º de janeiro de 2000
    function afterY2K() public view returns (uint[] memory, address[] memory) {
        // Unix timestamp para 1º de janeiro de 2000, 12:00am
        uint y2kTimestamp = 946702800;

        // Conta quantos timestamps são mais recentes que Y2K
        uint count = 0;
        for (uint i = 0; i < timestamps.length; i++) {
            if (timestamps[i] > y2kTimestamp) {
                count++;
            }
        }

        // Cria arrays para armazenar os resultados
        uint[] memory recentTimestamps = new uint[](count);
        address[] memory recentSenders = new address[](count);

        // Preenche os arrays com os valores correspondentes
        uint index = 0;
        for (uint i = 0; i < timestamps.length; i++) {
            if (timestamps[i] > y2kTimestamp) {
                recentTimestamps[index] = timestamps[i];
                recentSenders[index] = senders[i];
                index++;
            }
        }

        return (recentTimestamps, recentSenders);
    }

    // Função para redefinir o array de endereços
    function resetSenders() public {
        delete senders;
    }

    // Função para redefinir o array de timestamps
    function resetTimestamps() public {
        delete timestamps;
    }
}