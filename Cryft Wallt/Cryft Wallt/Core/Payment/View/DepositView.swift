//
//  DepositView.swift
//  Cryft Wallet
//
//  Created by Burhanuddin Jinwala on 12/14/23.
//

import SwiftUI

struct DepositView: View {
    @StateObject var viewModel = WalletViewModel()
    @State private var depositAmount: String = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var transactionSuccess = false
    var body: some View {
        ZStack {
            VStack {
                
                VStack{
                    
                    Text("Current Balance: ")
                        .font(.title)
                                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                .foregroundColor(.white)
                    Text("$\(viewModel.balance, specifier: "%.2f")")
                        .font(.title)
                                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                .foregroundColor(.white)
                        
                        }
                .padding(.top)
                        .frame(maxWidth: .infinity, maxHeight: 150)
                        .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.blue.opacity(0.7)]), startPoint: .topLeading, endPoint: .bottomTrailing))
                        .cornerRadius(15)
                
                Spacer()
                InputView(text: $depositAmount,
                          title: "Deposit Amount",
                          placeholder: "Enter Amount"
                          )
                .keyboardType(.decimalPad)
//                TextField("Enter Amount", text: $depositAmount)
//                    .keyboardType(.decimalPad)
//                    .textFieldStyle(RoundedBorderTextFieldStyle())
//                    .padding()
                
                Spacer()
                
                SlideToPayButton(amount: Double(depositAmount) ?? 0, message:"Deposit") {
                    if let amount = Double(depositAmount) {
                        print("deposit \(amount)")
                        let success = viewModel.deposit(amount: amount)
                        transactionSuccess = success
                        depositAmount = ""
                        alertMessage = success ? "Deposit Successful" : "Deposit Failed"
                        showAlert = true
                    } else {
                        transactionSuccess = false
                        alertMessage = "Invalid Amount"
                        showAlert = true
                    }
                    // Implement the payment logic here
                }
//                Button("Deposit") {
//                    
//                }
//                .padding()
//                .background(Color.blue)
//                .foregroundColor(.white)
//                .cornerRadius(10)
                
//                Spacer()
            }
            .padding()
            if showAlert {
                TransactionAlertView(isSuccess: transactionSuccess, message: alertMessage) {
                    showAlert = false
                }
            }
        }
                .padding()
                .onAppear {
                    viewModel.fetchWalletData()
                
        }
    }
}

#Preview {
    DepositView()
}
