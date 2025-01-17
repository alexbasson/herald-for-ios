//
//  SecurityTests.swift
//
//  Copyright 2021 Herald Project Contributors
//  SPDX-License-Identifier: Apache-2.0
//

import XCTest
@testable import CommonCrypto
@testable import Herald

class SecurityTests: XCTestCase {

    public func testKeyExchange() {
        let keyExchange = DiffieHellmanMerkle(DiffieHellmanParameters.modpGroup1)

        let (alicePrivateKey, alicePublicKey) = keyExchange.keyPair()!
        print("alice private key bytes: \(alicePrivateKey.count)")
        print("alice private key = \(alicePrivateKey.hexEncodedString)")
        print("alice public key bytes: \(alicePublicKey.count)")
        print("alice public key = \(alicePublicKey.hexEncodedString)")

        let (bobPrivateKey, bobPublicKey) = keyExchange.keyPair()!
        print("bob private key bytes: \(bobPrivateKey.count)")
        print("bob private key = \(bobPrivateKey.hexEncodedString)")
        print("bob public key bytes: \(bobPublicKey.count)")
        print("bob public key = \(bobPublicKey.hexEncodedString)")

        let aliceSharedKey = keyExchange.sharedKey(own: alicePrivateKey, peer: bobPublicKey)!
        print("alice shared key bytes: \(aliceSharedKey.count)")
        print("alice shared key = \(aliceSharedKey.hexEncodedString)")
        let bobSharedKey = keyExchange.sharedKey(own: bobPrivateKey, peer: alicePublicKey)!
        print("bob shared key bytes: \(bobSharedKey.count)")
        print("bob shared key = \(bobSharedKey.hexEncodedString)")

        XCTAssertEqual(aliceSharedKey, bobSharedKey)
    }
    
    public func testEncryption() throws {
        let encryption = AES128()
        let encryptionKey = EncryptionKey("key".data(using: .utf8)!)
        
        let message = "Hello"
        let encrypted = encryption.encrypt(data: message.data(using: .utf8)!, with: encryptionKey)!
        let decrypted = encryption.decrypt(data: encrypted, with: encryptionKey)!
        let decryptedMessage = String(bytes: decrypted, encoding: .utf8)!
        
        XCTAssertEqual(message, decryptedMessage)
    }
}
