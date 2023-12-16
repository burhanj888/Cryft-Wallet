//
//  MetamaskViewModel.swift
//  Cryft Wallet
//
//  Created by Burhanuddin Jinwala on 12/15/23.
//

import Foundation
import SwiftUI
import metamask_ios_sdk

class MetamaskViewModel : ObservableObject {
        
    let appMetadata = AppMetadata(name: "Dub Dapp", url: "https://dubdapp.com")
    
    init() {
    }
    
    func connectWallet() async{
        @ObservedObject var metamaskSDK = MetaMaskSDK.shared(appMetadata)

        var result = await metamaskSDK.connect()
        print("metamask: \(result)")
    }

    
    
}
