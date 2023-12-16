//
//  RegistrationView.swift
//  Cryft Wallt
//
//  Created by Burhanuddin Jinwala on 12/12/23.
//

import SwiftUI

struct RegistrationView: View {
    @State private var email = ""
    @State private var fullname = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var alertTitle = ""
    
    var body: some View {
        VStack{
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
                
                InputView(text: $fullname,
                title: "Full Name",
                placeholder: "Enter Your Name")
                
                InputView(text: $password,
                          title: "Password",
                          placeholder: "Enter your password",
                          isSecureField: true)
                
                ZStack(alignment:.trailing){
                    InputView(text: $confirmPassword,
                              title: "Confirm Password",
                              placeholder: "Comfirm your password",
                              isSecureField: true)
                    
                    if !password.isEmpty && !confirmPassword.isEmpty {
                        if password == confirmPassword {
                            Image(systemName: "checkmark.circle.fill")
                                .imageScale(.large)
                                .fontWeight(.bold)
                                .foregroundColor(Color(.systemGreen))
                        }
                        else {
                            Image(systemName: "xmark.circle.fill")
                                .imageScale(.large)
                                .fontWeight(.bold)
                                .foregroundColor(Color(.systemRed))
                        }
                    }
                }
            }
            .padding(.horizontal)
            
            Button{
                Task {
                        do {
                            try await viewModel.createUser(withEmail: email, password: password, fullname: fullname)
                            alertTitle = "Success"
                            alertMessage = "Registration successful! Welcome!"
                            showAlert = true
                        } catch {
                            alertTitle = "Error"
                            alertMessage = error.localizedDescription // Customize this message as needed
                            showAlert = true
                        }
                    }
            } label:{
                HStack{
                    Text("Sign Up")
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
            
            Button {
                dismiss()
            } label: {
                HStack(spacing: 3){
                    Text("Already have an account")
                    Text("Sign In")
                        .fontWeight(.bold)
                }
                .font(.system(size: 14))
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

extension RegistrationView : AuthenticationFormProtocol {
    var isFormValid: Bool {
        let isEmailValid = !email.isEmpty && email.contains("@") && email.contains(".")
        let isPasswordStrong = !password.isEmpty && password.count > 8 // Add more criteria as needed
        let isNameValid = !fullname.isEmpty && !fullname.contains(where: { $0.isNumber })
        return isEmailValid && isPasswordStrong && confirmPassword == password && isNameValid
    }
}

#Preview {
    RegistrationView()
}
