//
//  ProfileView.swift
//  Cryft Wallt
//
//  Created by Burhanuddin Jinwala on 12/12/23.
//

import SwiftUI

struct ProfileView: View {
    
    @EnvironmentObject var viewModel: AuthViewModel
    @StateObject var walletModel = WalletViewModel()
    @StateObject var Metamask = MetamaskViewModel()
    @State private var isBalanceVisible: Bool = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var alertTitle = ""
    
    var body: some View {
        if let user = viewModel.currentUser {
            List {
                Section {
                    HStack {
                        Text(user.initials)
                            .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(width: 72, height: 72)
                            .background(Color(.systemGray))
                            .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                        
                        VStack(alignment: .leading, spacing: 4){
                            Text(user.fullname)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .padding(.top, 4)
                            Text(user.email)
                                .font(.footnote)
                                .foregroundColor(.gray)
                        }
                    }
                }
                
                Section("Wallet"){
                    VStack(alignment: .leading) {
                                Text("Wallet")
                                    .font(.title)
                                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                    
                                    .foregroundColor(.white)
                        Text(user.id)
                                    .font(.subheadline)
                                    .foregroundColor(.white.opacity(0.7))
                        Spacer()
                                Spacer().frame(height: 20)
                                HStack {
                                    Text(isBalanceVisible ? "$\(String(walletModel.balance))" : "••••••")
                                        .font(.title2)
                                        .foregroundColor(.white)
                                    Spacer()
                                    Button(action: {
                                        isBalanceVisible.toggle()
                                    }) {
                                        Image(systemName: isBalanceVisible ? "eye.slash" : "eye")
                                            .foregroundColor(.white)
                                    }
                                }
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.blue.opacity(0.7)]), startPoint: .topLeading, endPoint: .bottomTrailing))
                            .cornerRadius(15)
                }
                
//                        .padding()
                Section("Account"){
                    Button{
                        print(viewModel.currentUser as Any, viewModel.userSession as Any)
                        viewModel.signOut()
                        
                    } label: {
                        SettingsRowView(imageName: "arrow.left.circle.fill", title: "Sign Out", tintColor: .red)
                    }
                    
//                    Button{
//                        Task{
//                            await Metamask.connectWallet()
//                        }
//                        
//                        print("Metamask")
//                    } label: {
//                        SettingsRowView(imageName: "xmark.circle.fill", title: "Metamask", tintColor: .red)
//                    }
//                    
                    Button{
                        Task {
                            do {
                                try await viewModel.deleteAccount()
                                alertTitle = "Success"
                                alertMessage = "Account Deleted!"
                                showAlert = true
                            } catch {
                                alertTitle = "Error"
                                alertMessage = error.localizedDescription // Customize this message as needed
                                showAlert = true
                            }
                        }
                        
                    } label: {
                        SettingsRowView(imageName: "xmark.circle.fill", title: "Delete Account", tintColor: .red)
                    }
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text(alertTitle),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
        
    }
    
}

#Preview {
    ProfileView()
}
