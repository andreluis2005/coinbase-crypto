// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

contract UnburnableToken {
    // Mapeamento para armazenar os saldos dos endereços
    mapping(address => uint256) public balances;

    // Variáveis de estado para o suprimento total e total reivindicado
    uint256 public totalSupply;
    uint256 public totalClaimed;

    // Eventos
    event TokensClaimedEvent(address indexed claimant, uint256 amount);
    event TokensTransferred(address indexed from, address indexed to, uint256 amount);

    // Erros personalizados
    error TokensAlreadyClaimed();
    error AllTokensClaimed();
    error UnsafeTransfer(address invalidAddress);

    // Construtor: define o suprimento total de tokens
    constructor() {
        totalSupply = 100_000_000 * 10**18; // 100 milhões de tokens (com 18 casas decimais)
    }

    // Função para reivindicar tokens
    function claim() public {
        // Verifica se o endereço já reivindicou tokens
        if (balances[msg.sender] > 0) {
            revert TokensAlreadyClaimed();
        }

        // Verifica se todos os tokens já foram reivindicados
        if (totalClaimed + 1000 * 10**18 > totalSupply) {
            revert AllTokensClaimed();
        }

        // Atualiza o saldo do reivindicante e o total reivindicado
        balances[msg.sender] += 1000 * 10**18;
        totalClaimed += 1000 * 10**18;

        // Emite um evento para registrar a reivindicação
        emit TokensClaimedEvent(msg.sender, 1000 * 10**18);
    }

    // Função para transferência segura de tokens
    function safeTransfer(address _to, uint256 _amount) public {
        // Verifica se o endereço de destino é válido
        if (_to == address(0)) {
            revert UnsafeTransfer(_to);
        }

        // Verifica se o endereço de destino tem saldo de ETH na Base Sepolia
        if (_to.balance == 0) {
            revert UnsafeTransfer(_to);
        }

        // Verifica se o remetente tem saldo suficiente
        require(balances[msg.sender] >= _amount, "Saldo insuficiente");

        // Realiza a transferência
        balances[msg.sender] -= _amount;
        balances[_to] += _amount;

        // Emite um evento para registrar a transferência
        emit TokensTransferred(msg.sender, _to, _amount);
    }
}