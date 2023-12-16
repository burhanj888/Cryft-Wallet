//
//  Transactions.swift
//  Cryft Wallet
//
//  Created by Burhanuddin Jinwala on 12/14/23.
//

import Foundation

struct Transaction: Identifiable, Codable {
    let id: String
    let type: TransactionType
    let amount: Double
    let userId: String
    let remark: String
    let date: Date

    enum TransactionType: String, Codable {
        case deposit, withdrawal, send, receive
    }
}
