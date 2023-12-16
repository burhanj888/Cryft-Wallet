//
//  WalletViewModel.swift
//  Cryft Wallet
//
//  Created by Burhanuddin Jinwala on 12/14/23.
//

import Foundation
import Firebase
import FirebaseFirestore

class WalletViewModel: ObservableObject {
    @Published var wallet: Wallet
    private var db = Firestore.firestore()

    init() {
        self.wallet = Wallet(initialBalance: 0.0)
        fetchWalletData()
    }

    var balance: Double {
        wallet.balance
    }

    // Fetch wallet data from Firestore
    func fetchWalletData() {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("User ID is nil")
            return
        }

        db.collection("user").document(userId).collection("wallet").document("walletData")
          .getDocument { snapshot, error in
            if let error = error {
                print("Error fetching wallet: \(error)")
                return
            }
            
            // Safely unwrap the wallet data
            guard let snapshot = snapshot, snapshot.exists,
                  let walletData = try? snapshot.data(as: Wallet.self) else {
                print("Wallet data not found or decoding error")
                return
            }

            DispatchQueue.main.async {
                self.wallet = walletData
            }
        }
    }


    // Update wallet data in Firestore
    func updateWallet() {
        guard let userId = Auth.auth().currentUser?.uid else { return }

        do {
            try db.collection("user").document(userId).collection("wallet")
                .document("walletData").setData(from: wallet)
        } catch let error {
            print("Error updating wallet: \(error)")
        }
    }

    func deposit(amount: Double) -> Bool {
        wallet.balance += amount
        let depositTransaction = Transaction(id: UUID().uuidString, type: .deposit, amount: amount, userId: Auth.auth().currentUser?.uid ?? "", remark: "Deposit from Metamask", date: Date())
        wallet.addTransaction(depositTransaction) // Use the addTransaction method
        updateWallet()
        return true
    }

    func withdraw(amount: Double) -> Bool {
        guard wallet.balance >= amount else { return false }
        wallet.balance -= amount
        let withdrawalTransaction = Transaction(id: UUID().uuidString, type: .withdrawal, amount: amount, userId: Auth.auth().currentUser?.uid ?? "", remark: "Withdrawal", date: Date())
        wallet.addTransaction(withdrawalTransaction)
        updateWallet()
        return true
    }

    func send(amount: Double, toUserId: String, remark: String) -> Bool {
        
        guard wallet.balance >= amount else { return false }
            wallet.balance -= amount

            // Record the 'send' transaction for the sender
            let sendTransaction = Transaction(id: UUID().uuidString, type: .send, amount: amount, userId: toUserId, remark: remark, date: Date())
            wallet.addTransaction(sendTransaction)

            // Update sender's wallet in Firestore
            updateWallet()

            // Fetch and update the recipient's wallet
            let recipientWalletRef = db.collection("user").document(toUserId).collection("wallet").document("walletData")
            recipientWalletRef.getDocument { (document, error) in
                if let document = document, var recipientWallet = try? document.data(as: Wallet.self) {
                    recipientWallet.balance += amount

                    // Record the 'receive' transaction for the recipient
                    let receiveTransaction = Transaction(id: UUID().uuidString, type: .receive, amount: amount, userId: Auth.auth().currentUser?.uid ?? "", remark: remark, date: Date())
                    recipientWallet.addTransaction(receiveTransaction)

                    // Update recipient's wallet in Firestore
                    try? recipientWalletRef.setData(from: recipientWallet)
                } else {
                    print("Error fetching recipient's wallet: \(error?.localizedDescription ?? "Unknown error")")
                }
            }

        return true
    }

    func receive(amount: Double, fromUserId: String, remark: String) {
        wallet.balance += amount
        let receiveTransaction = Transaction(id: UUID().uuidString, type: .receive, amount: amount, userId: fromUserId, remark: remark, date: Date())
        wallet.addTransaction(receiveTransaction)
        updateWallet()
    }

    func viewTransactions() -> [Transaction] {
        return wallet.transactions
    }
}
