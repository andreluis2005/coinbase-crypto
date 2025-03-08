// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

contract ErrorTriageExercise {
    // Array para armazenar números
    uint[] public arr;

    /**
     * Calcula a diferença absoluta entre cada uint e seu vizinho.
     * Retorna um array com as diferenças absolutas.
     */
    function diffWithNeighbor(
        uint _a,
        uint _b,
        uint _c,
        uint _d
    ) public pure returns (uint[] memory) {
        uint[] memory results = new uint[](3);

        // Calcula as diferenças absolutas
        results[0] = _a > _b ? _a - _b : _b - _a;
        results[1] = _b > _c ? _b - _c : _c - _b;
        results[2] = _c > _d ? _c - _d : _d - _c;

        return results;
    }

    /**
     * Aplica um modificador ao valor base.
     * O base deve ser sempre >= 1000.
     * O modificador deve estar entre -100 e 100.
     */
    function applyModifier(
        uint _base,
        int _modifier
    ) public pure returns (uint) {
        // Verifica se o base é válido
        require(_base >= 1000, "Base must be >= 1000");

        // Verifica se o modificador está dentro do intervalo permitido
        require(_modifier >= -100 && _modifier <= 100, "Modifier must be between -100 and 100");

        // Calcula o novo valor
        int newBase = int(_base) + _modifier;

        // Verifica se o novo valor é válido
        require(uint(newBase) >= 1000, "Base must remain >= 1000 after modification");

        return uint(newBase);
    }

    /**
     * Remove o último elemento do array e retorna o valor removido.
     */
    function popWithReturn() public returns (uint) {
        // Verifica se o array não está vazio
        require(arr.length > 0, "Array is empty");

        // Obtém o último elemento
        uint value = arr[arr.length - 1];

        // Remove o último elemento
        arr.pop();

        // Retorna o valor removido
        return value;
    }

    // Funções utilitárias (já funcionam corretamente)
    function addToArr(uint _num) public {
        arr.push(_num);
    }

    function getArr() public view returns (uint[] memory) {
        return arr;
    }

    function resetArr() public {
        delete arr;
    }
}