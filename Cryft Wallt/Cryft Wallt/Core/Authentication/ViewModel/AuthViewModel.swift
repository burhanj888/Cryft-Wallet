//
//  AuthViewModel.swift
//  Cryft Wallet
//
//  Created by Burhanuddin Jinwala on 12/12/23.
//

import Foundation
import Firebase
//import FirebaseAuth
import FirebaseAnalytics
import FirebaseFirestoreSwift

protocol AuthenticationFormProtocol {
    var isFormValid: Bool {get}
}

@MainActor
class AuthViewModel: ObservableObject {
    @Published var userSession: Firebase.User?
    @Published var currentUser: User?
    
    
    init() {
        self.userSession = Auth.auth().currentUser
        
        Task {
            await fetchUser()
        }
    }
    
    var userId: String? {
            return Auth.auth().currentUser?.uid
        }

    
    func signIn(withEmail email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            print(result.user)
            self.userSession = result.user
            await fetchUser()
        }
        catch {
            print("Debug: Failed to log in with error: \(error.localizedDescription)")
            throw error
        }
    }
    
    func createUser(withEmail email: String, password: String, fullname: String) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            let user = User(id: result.user.uid, fullname: fullname, email: email)
            let encodedUser = try Firestore.Encoder().encode(user)
            try await Firestore.firestore().collection("user").document(user.id).setData(encodedUser)
            await fetchUser()
        } catch {
            print("Debug: failed to create user with error \(error.localizedDescription)")
            throw error
        }
    }
    
    func signOut() {
        do {
            print("signout")
            self.userSession = nil
            self.currentUser = nil
            try Auth.auth().signOut()
            
            
        }
        catch {
            print("Debug: Failed to sign out with error \(error.localizedDescription)")
        }
    }
    
    func deleteAccount() async throws {
        guard let userId = userSession?.uid else {
                throw NSError(domain: "UserError", code: 0, userInfo: [NSLocalizedDescriptionKey: "No user logged in."])
            }

            let db = Firestore.firestore()

            do {
                // Delete user data from Firestore
                try await db.collection("user").document(userId).delete()

                // Delete the user's authentication record
                try await Auth.auth().currentUser?.delete()

                // Reset local session states
                userSession = nil
                currentUser = nil
            } catch {
                print("Debug: Failed to delete account with error \(error.localizedDescription)")
                throw error
            }
    }
    
    func fetchUser() async {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        guard let snapshot = try? await Firestore.firestore().collection("user").document(uid).getDocument() else { return }
        
        self.currentUser = try? snapshot.data(as: User.self)
        
    }
}

