// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

contract FavoriteRecords {
    // Mapeamento para armazenar álbuns aprovados
    mapping(string => bool) public approvedRecords;

    // Mapeamento para armazenar os favoritos dos usuários
    mapping(address => mapping(string => bool)) public userFavorites;

    // Erro personalizado para álbuns não aprovados
    error NotApproved(string recordName);

    // Construtor: carrega os álbuns aprovados
    constructor() {
        approvedRecords["Thriller"] = true;
        approvedRecords["Back in Black"] = true;
        approvedRecords["The Bodyguard"] = true;
        approvedRecords["The Dark Side of the Moon"] = true;
        approvedRecords["Their Greatest Hits (1971-1975)"] = true;
        approvedRecords["Hotel California"] = true;
        approvedRecords["Come On Over"] = true;
        approvedRecords["Rumours"] = true;
        approvedRecords["Saturday Night Fever"] = true;
    }

    // Função para retornar a lista de álbuns aprovados
    function getApprovedRecords() public pure returns (string[] memory) {
        // Lista de álbuns aprovados
        string[] memory records = new string[](9);
        records[0] = "Thriller";
        records[1] = "Back in Black";
        records[2] = "The Bodyguard";
        records[3] = "The Dark Side of the Moon";
        records[4] = "Their Greatest Hits (1971-1975)";
        records[5] = "Hotel California";
        records[6] = "Come On Over";
        records[7] = "Rumours";
        records[8] = "Saturday Night Fever";

        return records;
    }

    // Função para adicionar um álbum aos favoritos do usuário
    function addRecord(string memory _recordName) public {
        // Verifica se o álbum está na lista aprovada
        if (!approvedRecords[_recordName]) {
            revert NotApproved(_recordName);
        }

        // Adiciona o álbum aos favoritos do usuário
        userFavorites[msg.sender][_recordName] = true;
    }

    // Função para recuperar os favoritos de um usuário
    function getUserFavorites(address _user) public view returns (string[] memory) {
        // Conta quantos álbuns favoritos o usuário tem
        uint count = 0;
        string[] memory approved = getApprovedRecords();
        for (uint i = 0; i < approved.length; i++) {
            if (userFavorites[_user][approved[i]]) {
                count++;
            }
        }

        // Cria um array para armazenar os favoritos
        string[] memory favorites = new string[](count);
        uint index = 0;
        for (uint i = 0; i < approved.length; i++) {
            if (userFavorites[_user][approved[i]]) {
                favorites[index] = approved[i];
                index++;
            }
        }

        return favorites;
    }

    // Função para redefinir a lista de favoritos do usuário
    function resetUserFavorites() public {
        // Remove todos os favoritos do usuário
        string[] memory approved = getApprovedRecords();
        for (uint i = 0; i < approved.length; i++) {
            userFavorites[msg.sender][approved[i]] = false;
        }
    }
}