// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

// Importação da biblioteca SillyStringUtils
import "./SillyStringUtils.sol";

contract ImportsExercise {
    // Uso da struct Haiku da biblioteca
    using SillyStringUtils for SillyStringUtils.Haiku;

    // Variável pública para armazenar o haiku
    SillyStringUtils.Haiku public haiku;

    // Função para salvar o haiku
    function saveHaiku(string memory _line1, string memory _line2, string memory _line3) public {
        haiku.line1 = _line1;
        haiku.line2 = _line2;
        haiku.line3 = _line3;
    }

    // Função para recuperar o haiku
    function getHaiku() public view returns (SillyStringUtils.Haiku memory) {
        return haiku;
    }

    // Função para adicionar "🤷" à terceira linha do haiku (sem modificar o original)
    function shruggieHaiku() public view returns (SillyStringUtils.Haiku memory) {
        SillyStringUtils.Haiku memory modifiedHaiku = haiku;
        modifiedHaiku.line3 = SillyStringUtils.shruggie(modifiedHaiku.line3);
        return modifiedHaiku;
    }
}