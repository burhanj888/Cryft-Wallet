//
//  TransactionAlertView.swift
//  Cryft Wallet
//
//  Created by Burhanuddin Jinwala on 12/14/23.
//

import SwiftUI

struct TransactionAlertView: View {
    let isSuccess: Bool
    let message: String
    var onClose: () -> Void
    var body: some View {
        VStack(spacing: 20) {
            HStack{
                Spacer()
                        Button(action: onClose) {
                            Image(systemName: "xmark")
                                .foregroundColor(.black)
                                
                        }
                    }

                    Image(systemName: isSuccess ? "checkmark.circle.fill" : "xmark.circle.fill")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .foregroundColor(isSuccess ? .green : .red)

                    Text(message)
                        .font(.title3)
                        .multilineTextAlignment(.center)
                }
                .padding()
                .frame(width: 300, height: 200)
                .background(Color.white)
                .cornerRadius(15)
                .shadow(radius: 10)
    }
}

#Preview {
    TransactionAlertView(isSuccess: true, message: "Transaction Successful", onClose: {})
}
