//
//  TransactionHistoryView.swift
//  Cryft Wallet
//
//  Created by Burhanuddin Jinwala on 12/13/23.
//

import SwiftUI

struct TransactionHistoryView: View {
    
    @ObservedObject var viewModel: WalletViewModel
    @State private var searchText: String = ""
    
    var body: some View {
        VStack{
            
        TextField("Search", text: $searchText)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding()
            List(viewModel.wallet.transactions.reversed().filter(filterTransactions)) { transaction in
                VStack(alignment: .leading) {
                    HStack {
                        Image(systemName: transactionTypeIcon(transaction.type))
                            .foregroundColor(transactionTypeColor(transaction.type))
                        Text(transaction.type.rawValue.capitalized)
                            .font(.headline)
                            .foregroundColor(transactionTypeColor(transaction.type))
                        Spacer()
                        Text(transaction.date, formatter: itemFormatter)
                    }
                    Text("Amount: ₹\(transaction.amount, specifier: "%.2f")")
                    if transaction.type == .send {
                        Text("To: \(transaction.userId)")
                    } else if transaction.type == .receive {
                        Text("From: \(transaction.userId)")
                    }
                    if !transaction.remark.isEmpty {
                        Text("Remark: \(transaction.remark)")
                    }
                }
                .padding()
            }
                }
                .onAppear {
                    viewModel.fetchWalletData()
                }
        
    }
    
    private func filterTransactions(_ transaction: Transaction) -> Bool {
            let searchTextLowercased = searchText.lowercased()

            let matchesAmount = String(transaction.amount).lowercased().contains(searchTextLowercased)
            let matchesType = transaction.type.rawValue.lowercased().contains(searchTextLowercased)
            let matchesRemark = transaction.remark.lowercased().contains(searchTextLowercased)

            return searchText.isEmpty || matchesAmount || matchesType || matchesRemark
        }
        
    private var itemFormatter: DateFormatter {
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            formatter.timeStyle = .short
            return formatter
        }
    
    private func transactionTypeIcon(_ type: Transaction.TransactionType) -> String {
            switch type {
            case .withdrawal, .send:
                return "arrow.up.right"
            case .deposit, .receive:
                return "arrow.down.left"
            default:
                return "questionmark.circle"
            }
        }

        private func transactionTypeColor(_ type: Transaction.TransactionType) -> Color {
            switch type {
            case .withdrawal, .send:
                return Color.red
            case .deposit, .receive:
                return Color.green
            default:
                return Color.gray
            }
        }

        private func transactionTypeBackground(_ type: Transaction.TransactionType) -> Color {
            switch type {
            case .withdrawal, .send:
                return Color.red.opacity(0.1)
            case .deposit, .receive:
                return Color.green.opacity(0.1)
            default:
                return Color.gray.opacity(0.1)
            }
        }
}

#Preview {
    TransactionHistoryView(viewModel: WalletViewModel())
}
