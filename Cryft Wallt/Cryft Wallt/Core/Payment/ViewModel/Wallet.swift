//
//  Wallet.swift
//  Cryft Wallet
//
//  Created by Burhanuddin Jinwala on 12/14/23.
//

import Foundation

class Wallet: Codable {
    var balance: Double
    var transactions: [Transaction] = []
    
    init(initialBalance: Double = 0.00) {
        self.balance = initialBalance
    }
    
    func addTransaction(_ transaction: Transaction) {
            transactions.append(transaction)
        }
    
    func deposit(amount: Double, userId: String, remark: String) {
        balance += amount
        let depositTransaction = Transaction(id: UUID().uuidString, type: .deposit, amount: amount, userId: userId, remark: remark, date: Date())
        transactions.append(depositTransaction)
    }
    
    func withdraw(amount: Double, userId: String, remark: String) -> Bool {
        guard balance >= amount else { return false }
        balance -= amount
        let withdrawalTransaction = Transaction(id: UUID().uuidString, type: .withdrawal, amount: amount, userId: userId, remark: remark, date: Date())
        transactions.append(withdrawalTransaction)
        return true
    }
    
    func viewTransactions() -> [Transaction] {
        return transactions
    }
    
    func send(amount: Double, fromUserId: String, toUserId: String, remark: String) -> Bool {
        guard balance >= amount else { return false }
        balance -= amount
        let sendTransaction = Transaction(id: UUID().uuidString, type: .send, amount: amount, userId: fromUserId, remark: remark, date: Date())
        transactions.append(sendTransaction)
        return true
    }
    
    func receive(amount: Double, fromUserId: String, remark: String) {
        balance += amount
        let receiveTransaction = Transaction(id: UUID().uuidString, type: .receive, amount: amount, userId: fromUserId, remark: remark, date: Date())
        transactions.append(receiveTransaction)
    }
    // Additional functions for transferring and receiving can be added here...
}
