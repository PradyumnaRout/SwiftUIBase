//
//  AES256.swift
//  PlugOrganizer
//
//  Created by hb on 22/04/25.
//

import Foundation
import CryptoKit


enum AESError: Error {
    case encryptionFailed
    case decryptionFailed
    case invalidKey
}

class AES256 {
    static let shared = AES256()

    private let keyString = AppConstants.aesEncryptionKey // 32 characters = 256 bits
    private var symmetricKey: SymmetricKey {
        SymmetricKey(data: Data(keyString.utf8))
    }

    func encrypt(string: String) throws -> Data {
        let data = Data(string.utf8)
        let sealedBox = try AES.GCM.seal(data, using: symmetricKey)
        guard let combined = sealedBox.combined else {
            throw AESError.encryptionFailed
        }
        return combined
    }

    func decrypt(data: Data) throws -> String {
        let sealedBox = try AES.GCM.SealedBox(combined: data)
        let decrypted = try AES.GCM.open(sealedBox, using: symmetricKey)
        guard let string = String(data: decrypted, encoding: .utf8) else {
            throw AESError.decryptionFailed
        }
        return string
    }
}
