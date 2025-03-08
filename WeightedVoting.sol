// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";

contract WeightedVoting is ERC20 {
    using EnumerableSet for EnumerableSet.AddressSet;

    // Constantes
    uint256 public constant MAX_SUPPLY = 1_000_000;

    // Erros personalizados
    error TokensClaimed();
    error AllTokensClaimed();
    error NoTokensHeld();
    error QuorumTooHigh(uint256 quorum);
    error AlreadyVoted();
    error VotingClosed();

    // Struct para representar uma questão
    struct Issue {
        EnumerableSet.AddressSet voters;
        string issueDesc;
        uint256 votesFor;
        uint256 votesAgainst;
        uint256 votesAbstain;
        uint256 totalVotes;
        uint256 quorum;
        bool passed;
        bool closed;
    }

    // Array de questões (não é público)
    Issue[] private issues;

    // Enum para representar o voto
    enum Vote {
        AGAINST,
        FOR,
        ABSTAIN
    }

    // Construtor
    constructor() ERC20("WeightedVotingToken", "WVT") {
        // Inicializa o array de questões com uma questão vazia
        issues.push();
    }

    // Função para reivindicar tokens
    function claim() public {
        // Verifica se o endereço já reivindicou tokens
        if (balanceOf(msg.sender) > 0) {
            revert TokensClaimed();
        }

        // Verifica se todos os tokens já foram reivindicados
        if (totalSupply() + 100 > MAX_SUPPLY) {
            revert AllTokensClaimed();
        }

        // Mint de 100 tokens para o reivindicante
        _mint(msg.sender, 100);
    }

    // Função para criar uma nova questão
    function createIssue(string memory _issueDesc, uint256 _quorum) external returns (uint256) {
        // Verifica se o chamador possui tokens
        if (balanceOf(msg.sender) == 0) {
            revert NoTokensHeld();
        }

        // Verifica se o quorum é válido
        if (_quorum > totalSupply()) {
            revert QuorumTooHigh(_quorum);
        }

        // Cria uma nova questão
        Issue storage newIssue = issues.push();
        newIssue.issueDesc = _issueDesc;
        newIssue.quorum = _quorum;

        // Retorna o índice da nova questão
        return issues.length - 1;
    }

    // Função para obter os dados de uma questão
    function getIssue(uint256 _id) external view returns (
        string memory,
        uint256,
        uint256,
        uint256,
        uint256,
        uint256,
        bool,
        bool
    ) {
        require(_id < issues.length, unicode"Questão não encontrada");

        Issue storage issue = issues[_id];
        return (
            issue.issueDesc,
            issue.votesFor,
            issue.votesAgainst,
            issue.votesAbstain,
            issue.totalVotes,
            issue.quorum,
            issue.passed,
            issue.closed
        );
    }

    // Função para votar em uma questão
    function vote(uint256 _issueId, Vote _vote) public {
        // Verifica se a questão existe
        require(_issueId < issues.length, unicode"Questão não encontrada");

        Issue storage issue = issues[_issueId];

        // Verifica se a votação está fechada
        if (issue.closed) {
            revert VotingClosed();
        }

        // Verifica se o endereço já votou
        if (issue.voters.contains(msg.sender)) {
            revert AlreadyVoted();
        }

        // Adiciona o endereço ao conjunto de votantes
        issue.voters.add(msg.sender);

        // Obtém o saldo de tokens do votante
        uint256 voteWeight = balanceOf(msg.sender);

        // Adiciona o voto ao total apropriado
        if (_vote == Vote.FOR) {
            issue.votesFor += voteWeight;
        } else if (_vote == Vote.AGAINST) {
            issue.votesAgainst += voteWeight;
        } else if (_vote == Vote.ABSTAIN) {
            issue.votesAbstain += voteWeight;
        }

        // Atualiza o total de votos
        issue.totalVotes += voteWeight;

        // Verifica se o quorum foi atingido
        if (issue.totalVotes >= issue.quorum) {
            issue.closed = true;
            issue.passed = issue.votesFor > issue.votesAgainst;
        }
    }
}