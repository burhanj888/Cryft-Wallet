//
//  RecieveView.swift
//  Cryft Wallet
//
//  Created by Burhanuddin Jinwala on 12/13/23.
//

import SwiftUI

struct RecieveView: View {
    
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var qrCodeImage: UIImage?
    
    var body: some View {
        if let user = viewModel.currentUser {
            VStack(alignment: .center) {
                        Spacer()

                        Text("Receive Money on This QR Code")
                    .font(.headline)
                
                            .padding()

                Text("Pay by Email: \(user.email.lowercased())")
                                .font(.headline)
                                .padding()
                HStack {
                    Line()
                    Text("OR")
                        .padding(.horizontal, 5)
                    Line()
                }
                .frame(height: 1)

                        if let qrCodeImage = qrCodeImage {
                            Image(uiImage: qrCodeImage)
                                .resizable()
                                .scaledToFit()
                                .padding()
                        } else {
                            Text("QR Code Unavailable")
                        }

                        Spacer()
                    }
            .padding()
            .onAppear {
                generateQRCodeForUserID()
            }
        }
        
    }
    private func generateQRCodeForUserID() {
        if let userId = viewModel.userId {
                qrCodeImage = generateQRCode(from: userId)
            }
        }
}

struct Line: View {
    var body: some View {
        Rectangle()
            .frame(height: 1)
            .foregroundColor(.gray)
    }
}

#Preview {
    RecieveView()
}
