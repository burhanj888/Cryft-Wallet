//
//  SendView.swift
//  Cryft Wallet
//
//  Created by Burhanuddin Jinwala on 12/13/23.
//

import SwiftUI
import FirebaseFirestore

struct SendView: View {
    @StateObject var viewModel: WalletViewModel = WalletViewModel()
        var recipientEmail: String
    @Binding var showSendMoneyView: Bool

        @State private var recipientUserId: String = ""
        @State private var recipientFullName: String = ""
       @State private var amount: String = ""
       @State private var remark: String = ""
    @State private var alertMessage = ""
    @State private var transactionSuccess = false
    @State private var showAlert = false
    @State private var isSendingMoney: Bool = false

        // Add other properties you might need
        // ...

    init(recipientEmail: String, showSendMoneyView: Binding<Bool>) {
            self.recipientEmail = recipientEmail
            self._showSendMoneyView = showSendMoneyView  // Note the underscore for bindings
        }

    var body: some View {
        ZStack{
            VStack(alignment: .center) {
                VStack{
                    Text("Available Balance: ")
                        .font(.title)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .foregroundColor(.white)
                    Text("$\(viewModel.balance, specifier: "%.2f")")
                        .font(.title)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .foregroundColor(.white)
                    Spacer()
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: 100)
                .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.blue.opacity(0.7)]), startPoint: .topLeading, endPoint: .bottomTrailing))
                .cornerRadius(15)
                if !recipientUserId.isEmpty && !recipientFullName.isEmpty {
                    Text("You are sending money to : \(recipientFullName)")
                        .font(.headline)
                    // ... rest of your UI
                } else {
                    Text("Fetching user details...")
                }
                InputView(text: $amount,
                          title: "Amount",
                          placeholder: "Enter Amount"
                          )
                    .keyboardType(.decimalPad)
                    .padding()

                InputView(text: $recipientUserId,
                          title: "Recipient User ID",
                          placeholder: "Recipient User ID"
                          )
                .padding()
                
                InputView(text: $remark,
                          title: "Remark",
                          placeholder: "Remark (Optional)"
                          )
                .padding()
                
                
                SlideToPayButton(amount: Double(amount) ?? 0, message: "Pay") {
                    sendMoney()
                    // Implement the payment logic here
                }
                .padding()
                
                
                Spacer()
            }
            
            .onAppear {
                fetchUserDetails(from: recipientEmail)
            }
            .padding()
            if showAlert {
                TransactionAlertView(isSuccess: transactionSuccess, message: alertMessage) {
                    showAlert = false
                }
        }
        
        }
        
    }
    
    private func sendMoney() {
            guard let amountToSend = Double(amount), amountToSend > 0 else {
                alertMessage = "Please enter a valid amount"
                showAlert = true
                return
            }

            guard amountToSend <= viewModel.balance else {
                alertMessage = "Insufficient balance"
                showAlert = true
                return
            }

            let success = viewModel.send(amount: amountToSend, toUserId: recipientUserId, remark: remark)
            if success {
                amount = ""
                recipientUserId = ""
                remark = ""
                alertMessage = "Money sent successfully"
                showAlert = true
                transactionSuccess = true
                
            } else {
                alertMessage = "Transaction failed"
            }
            showAlert = true
        }
    
    private func fetchUserDetails(from email: String) {
        print(email)
        print("in func")
            let db = Firestore.firestore()
        let userRef = db.collection("user")
        userRef.whereField("email", isEqualTo: email)
            .getDocuments { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                }else if let snapshot = querySnapshot, snapshot.documents.isEmpty {
                    // Handle the case where no user is found
                    print("No user found")
                    // Update UI or state accordingly
                    showAlert = true
                    alertMessage = "User Not Found"
                }
                else {
                    for document in querySnapshot!.documents {
                        let data = document.data()
                        print(data)
                        recipientUserId = document.documentID
                        recipientFullName = data["fullname"] as? String ?? ""
                    }
                }
            }
        
        }
}

struct SlideToPayButton: View {
    var amount: Double
    var message: String // Assuming this is passed to the view to display the amount to be paid
    @State private var offset = CGSize.zero
    @State private var isCompleted = false

    var onSlideComplete: () -> Void = {} // Callback when the slide is completed

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: geometry.size.height / 2)
                    .fill(Color.green)
                
                Text("Slide to \(message) | $\(String(format: "%.0f", amount))")
                    .foregroundColor(.white)
                    .padding(.leading, 75)
                
                Circle()
                    .frame(width: geometry.size.height, height: geometry.size.height)
                    .foregroundColor(.white)
                    .overlay(
                        Image(systemName: "chevron.right.2")
                            .font(.title)
                            .foregroundColor(.green)
                            
                    )
                    
                    .padding(.leading, offset.width)
                    .gesture(
                        DragGesture()
                            .onChanged { gesture in
                                if gesture.translation.width > 0 && gesture.translation.width < (geometry.size.width - geometry.size.height) {
                                    self.offset.width = gesture.translation.width
                                }
                            }
                            .onEnded { _ in
                                if self.offset.width > geometry.size.width * 0.8 {
                                    self.offset.width = geometry.size.width - geometry.size.height
                                    self.isCompleted = true
                                    self.onSlideComplete()
                                } else {
                                    self.offset = .zero
                                }
                            }
                    )
            }
        }
        .frame(height: 50)
        .cornerRadius(25)
        .padding()
        .onChange(of: isCompleted) {
            if isCompleted { // If isCompleted is true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.offset = .zero
                    self.isCompleted = false
                }
            }
        }
    }
}

#Preview {
    SendView(recipientEmail: "example@email.com", showSendMoneyView: .constant(true))
}
