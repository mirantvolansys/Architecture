//
//  Encryption_Utility.swift
//  BasicUtilities
//
//  Created by Shrenik on 18/07/19.
//  Copyright © 2019 Volansys. All rights reserved.
//

import Foundation
import CryptoSwift

let ivData = AES.randomIV(AES.blockSize)    // 16-Bit iv data

// NOTE : Based on Key size, Encryption Algorithm will get decided. i.e. for 16-bit Key, AES-128 (16*8 = 128) and for 32-Bit key AES-256 Algorithm will get applied.

// MARK: - String Extension
extension String {
    // Base-64 Decoded
    var base64Decoded: String? {
        guard let decodedData = Data(base64Encoded: self) else { return nil }
        return String(data: decodedData, encoding: .utf8)
    }
    
    // Base-64 Encoded
    var base64Encoded: String? {
        let plainData = data(using: .utf8)
        return plainData?.base64EncodedString()
    }
    
    /// Encrypt String using key
    ///
    /// - Parameter key: Key
    /// - Returns: Encrypted String
    /// - Throws: exception / error message
    func encrypt(key: String) throws -> String {
        let data: [UInt8] = Array(self.utf8)
        let encrypted = try AES(key: key.bytes, blockMode: CBC(iv: ivData), padding: .pkcs7).encrypt(data)
        return Data(encrypted).base64EncodedString()
    }
    
    /// Decrypted string
    ///
    /// - Parameter key: Key
    /// - Returns: Original/Decrypted message
    /// - Throws: Exception/ error message
    func decrypt(key: String) throws -> String {
        guard let data = Data(base64Encoded: self) else { return "" }
        let decrypted = try AES(key: key.bytes, blockMode: CBC(iv: ivData), padding: .pkcs7).decrypt([UInt8](data))
        return String(bytes: decrypted, encoding: .utf8) ?? self
    }
}
