// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/// @notice All owners are assumed to be externally owned accounts (EOAs), not smart contracts.
/// @dev Since owners are EOAs, reentrancy protection is not required for executing transactions.
contract Comitiva {
	address[] public owners;
	uint public threshold;

	struct Transaction {
		address to;
		uint value;
		bool executed;
		uint confirmations;
	}

	Transaction[] public transactions;
	mapping(uint => mapping(address => bool)) public isConfirmed;

	constructor(address[] memory _owners, uint _threshold) {
		require(_owners.length > 0);
		require(_threshold > 0 && _threshold <= _owners.length);

		owners = _owners;
		threshold = _threshold;
	}

	modifier onlyOwner() {
		bool ownerFound = false;
		for (uint i = 0; i < owners.length; i++) {
			if(owners[i] == msg.sender) {
				ownerFound = true;
				break;
			}
		}
		require(ownerFound, "Abort: not an owner");
		_;
	}

	modifier txExists(uint _txId) {
		require(_txId < transactions.length, "Transaction does not exist"); // _txId within the bound of the array
		_;
	}

	modifier notExecuted(uint _txId) {
		require(!transactions[_txId].executed, "Transaction already executed");
		_;
	}

	modifier notConfirmed(uint _txId) {
		require(!isConfirmed[_txId][msg.sender], "Transaction already confirmed");
		_;
	}

	receive() external payable {}

	function submitTransaction(address _to, uint _value) external onlyOwner {
		transactions.push(Transaction({
			to: _to,
			value: _value,
			executed: false,
			confirmations: 0
		}));
	}

	function confirmTransaction(uint _txId) external onlyOwner txExists(_txId) notExecuted(_txId) notConfirmed(_txId) {
		isConfirmed[_txId][msg.sender] = true;
		transactions[_txId].confirmations += 1;

		if (transactions[_txId].confirmations >= threshold) {
			executeTransaction(_txId);
		}
	}

	function executeTransaction(uint _txId) internal txExists(_txId) notExecuted(_txId) {
		Transaction storage pendingTransaction = transactions[_txId];
		require(pendingTransaction.confirmations >= threshold, "Not enough confirmations");

		pendingTransaction.executed = true;
		(bool success, ) = pendingTransaction.to.call{value: pendingTransaction.value}("");
		require(success, "Transaction failed");
	}

	function getOwners() external view returns (address[] memory) {
		return owners;
	}

}