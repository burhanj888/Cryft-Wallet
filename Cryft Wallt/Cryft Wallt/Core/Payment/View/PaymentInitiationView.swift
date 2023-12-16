//
//  PaymentInitiationView.swift
//  Cryft Wallet
//
//  Created by Burhanuddin Jinwala on 12/15/23.
//

import SwiftUI

enum NavigationItem {
    case sendMoney(String)
}

class NavigationViewModel: ObservableObject {
    @Published var shouldNavigate: Bool = false
}

struct PaymentInitiationView: View {
    @State private var recipientEmailOrCode: String = ""
        @State private var showSendMoneyView: Bool = false
    @State private var showAlert = false
    @StateObject var navigationViewModel = NavigationViewModel()
    var body: some View {
        NavigationStack {
                    VStack {
                        Spacer()
                        Text("Pay by Email or Scan QR Code")
                            .font(.headline)
                        InputView(text: $recipientEmailOrCode,
                                  title: "Email",
                                  placeholder: "Enter Email or Scan QR Code"
                                  )
                            .padding()

                        Button("Scan QR Code") {
                            showAlert = true
                        }
                        .padding()
                        Spacer()
                        Button{
                            showSendMoneyView = true
                        } label:{
                            HStack{
                                Text("Pay")
                                    .fontWeight(.semibold)
                            
                            }.foregroundColor(.white)
                                .frame(width: UIScreen.main.bounds.width - 32, height: 48)
                        }
                        .background(Color(.systemBlue))
                        .cornerRadius(10)
                        .padding(.top, 24)
                        .disabled(recipientEmailOrCode.isEmpty)
                        .navigationDestination(isPresented: $showSendMoneyView) {
                            SendView(recipientEmail: recipientEmailOrCode.lowercased(), showSendMoneyView: $showSendMoneyView)
                        }

                        
                    }
                                    }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Alert"),
                message: Text("Open in Real Device!"),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

#Preview {
    PaymentInitiationView()
}
