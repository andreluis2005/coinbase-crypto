// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract HaikuNFT is ERC721 {
    using Strings for uint256;

    // Struct para armazenar um haiku
    struct Haiku {
        address author;
        string line1;
        string line2;
        string line3;
    }

    // Array para armazenar haikus
    Haiku[] public haikus;

    // Mapeamento para relacionar haikus compartilhados
    mapping(address => uint256[]) public sharedHaikus;

    // Contador para IDs de haikus
    uint256 public nextHaikuId = 1;

    // Erros personalizados
    error HaikuNotUnique();
    error NotYourHaiku(uint256 haikuId);
    error NoHaikusShared();

    // Construtor
    constructor() ERC721("HaikuNFT", "HKT") {}

    // Função para cunhar um haiku
    function mintHaiku(string memory _line1, string memory _line2, string memory _line3) external {
        // Verifica se o haiku é único
        if (!isHaikuUnique(_line1, _line2, _line3)) {
            revert HaikuNotUnique();
        }

        // Cria o haiku
        haikus.push(Haiku({
            author: msg.sender,
            line1: _line1,
            line2: _line2,
            line3: _line3
        }));

        // Cunha o NFT para o autor
        _mint(msg.sender, nextHaikuId);

        // Incrementa o contador de IDs
        nextHaikuId++;
    }

    // Função para compartilhar um haiku
    function shareHaiku(uint256 _haikuId, address _to) public {
        // Verifica se o chamador é o proprietário do haiku
        if (ownerOf(_haikuId) != msg.sender) {
            revert NotYourHaiku(_haikuId);
        }

        // Adiciona o haiku à lista de haikus compartilhados do destinatário
        sharedHaikus[_to].push(_haikuId);
    }

    // Função para obter haikus compartilhados com o chamador
    function getMySharedHaikus() public view returns (uint256[] memory) {
        // Verifica se há haikus compartilhados
        if (sharedHaikus[msg.sender].length == 0) {
            revert NoHaikusShared();
        }

        // Retorna a lista de haikus compartilhados
        return sharedHaikus[msg.sender];
    }

    // Função para verificar se um haiku é único
    function isHaikuUnique(string memory _line1, string memory _line2, string memory _line3) private view returns (bool) {
        for (uint256 i = 0; i < haikus.length; i++) {
            if (
                keccak256(bytes(haikus[i].line1)) == keccak256(bytes(_line1)) ||
                keccak256(bytes(haikus[i].line2)) == keccak256(bytes(_line2)) ||
                keccak256(bytes(haikus[i].line3)) == keccak256(bytes(_line3))
            ) {
                return false;
            }
        }
        return true;
    }

    // Função para retornar o URI do token (opcional, para metadados)
    function tokenURI(uint256 _tokenId) public view override returns (string memory) {
        // Verifica se o token existe
        require(ownerOf(_tokenId) != address(0), "Token nao existe");

        Haiku memory haiku = haikus[_tokenId - 1]; // IDs começam em 1
        return string(
            abi.encodePacked(
                "data:application/json;utf8,{",
                '"name":"Haiku #",', _tokenId.toString(), '",',
                '"description":"Um haiku unico.",',
                '"attributes":[',
                '{"trait_type":"Autor","value":"', Strings.toHexString(uint256(uint160(haiku.author)), 20), '"},',
                '{"trait_type":"Linha 1","value":"', haiku.line1, '"},',
                '{"trait_type":"Linha 2","value":"', haiku.line2, '"},',
                '{"trait_type":"Linha 3","value":"', haiku.line3, '"}',
                ']}'
            )
        );
    }
}