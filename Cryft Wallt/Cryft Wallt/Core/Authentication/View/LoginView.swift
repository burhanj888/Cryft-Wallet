//
//  LoginView.swift
//  Cryft Wallt
//
//  Created by Burhanuddin Jinwala on 12/12/23.
//

import SwiftUI

struct LoginView: View {
    
    @State private var email = ""
    @State private var password = ""
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var alertTitle = ""
    
    var body: some View {
        NavigationStack{
            NavigationStack{
                VStack {
                    Image("Cryft logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 250, height: 200)
                        .padding(.vertical, 32)
                    
                    
                    VStack(spacing: 24){
                        InputView(text: $email,
                        title: "Email Address",
                        placeholder: "name@example.com")
                        .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                        
                        InputView(text: $password,
                                  title: "Password",
                                  placeholder: "Enter your password",
                                  isSecureField: true)
                    }
                    .padding(.horizontal)
                    
                    Button{
                        Task {
                            do {
                                try await viewModel.signIn(withEmail: email, password: password)
                                alertTitle = "Success"
                                alertMessage = "Login successful! Welcome Back!"
                                showAlert = true
                            } catch {
                                alertTitle = "Error"
                                alertMessage = error.localizedDescription // Customize this message as needed
                                showAlert = true
                            }
                        }
                        
                    } label:{
                        HStack{
                            Text("Sign In")
                                .fontWeight(.semibold)
                            Image(systemName: "arrow.right")
                        }.foregroundColor(.white)
                            .frame(width: UIScreen.main.bounds.width - 32, height: 48)
                    }
                    .background(Color(.systemBlue))
                    .disabled(!isFormValid)
                    .opacity(isFormValid ? 1.0 : 0.5)
                    .cornerRadius(10)
                    .padding(.top, 24)
                    
                    Spacer()
                    
                    NavigationLink {
                        RegistrationView()
                            .navigationBarBackButtonHidden(true)
                    } label: {
                        HStack(spacing: 3){
                            Text("Don't have an account?")
                            Text("Sign Up")
                                .fontWeight(.bold)
                        }
                        .font(.system(size: 14))
                    }
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

extension LoginView: AuthenticationFormProtocol {
    var isFormValid: Bool{
        return !email.isEmpty && email.contains("@") && email.contains(".")
        && !password.isEmpty && password.count > 6
        
    }
}

#Preview {
    LoginView()
}
