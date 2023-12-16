//
//  QRCodeGenerator.swift
//  Cryft Wallet
//
//  Created by Burhanuddin Jinwala on 12/15/23.
//

import Foundation
import SwiftUI
import CoreImage.CIFilterBuiltins

func generateQRCode(from string: String) -> UIImage {
        let context = CIContext()
        let filter = CIFilter.qrCodeGenerator()
        let data = Data(string.utf8)
        filter.setValue(data, forKey: "inputMessage")

        let transform = CGAffineTransform(scaleX: 10, y: 10) // Scale up the image

        if let outputImage = filter.outputImage?.transformed(by: transform) {
            if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgimg)
            }
        }

        return UIImage(systemName: "xmark.circle") ?? UIImage() // Fallback image
    }
