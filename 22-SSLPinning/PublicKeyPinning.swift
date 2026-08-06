//
//  PublicKeyPinning.swift
//  ADVANCED — pin the server's PUBLIC KEY instead of the whole certificate.
//
//  Why: a certificate expires and gets renewed roughly yearly; if you pinned the
//  certificate, your app breaks on renewal. The public key usually stays the same
//  across renewals, so pinning it means fewer forced app updates.
//
//  We compare a SHA-256 hash of the server's public key against a hash we hard-code.
//

import Foundation
import CryptoKit

final class PublicKeyPinningDelegate: NSObject, URLSessionDelegate {

    /// Base64-encoded SHA-256 hashes of the public keys you trust.
    /// Pin TWO (current + a backup key) so you can rotate without an app update.
    /// Get the hash with an SSL-pinning tool, or compute it once and print it.
    private let pinnedKeyHashes: Set<String> = [
        "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=",   // ← replace with your real hash
        "BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB="    // ← backup key hash
    ]

    func urlSession(
        _ session: URLSession,
        didReceive challenge: URLAuthenticationChallenge,
        completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void
    ) {
        guard challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust,
              let serverTrust = challenge.protectionSpace.serverTrust,
              let certificate = certificate(from: serverTrust),
              let publicKey = SecCertificateCopyKey(certificate),
              let keyData = SecKeyCopyExternalRepresentation(publicKey, nil) as Data?
        else {
            completionHandler(.cancelAuthenticationChallenge, nil)
            return
        }

        // Hash the server's public key and Base64-encode it.
        let serverKeyHash = sha256Base64(keyData)

        // Allow only if the hash is one we pinned.
        if pinnedKeyHashes.contains(serverKeyHash) {
            completionHandler(.useCredential, URLCredential(trust: serverTrust))
        } else {
            completionHandler(.cancelAuthenticationChallenge, nil)
        }
    }

    // MARK: - Helpers

    private func certificate(from trust: SecTrust) -> SecCertificate? {
        if #available(iOS 15.0, *) {
            return (SecTrustCopyCertificateChain(trust) as? [SecCertificate])?.first
        } else {
            return SecTrustGetCertificateAtIndex(trust, 0)
        }
    }

    /// SHA-256 → Base64. Note: real HPKP hashes the DER-encoded SubjectPublicKeyInfo
    /// (key + an ASN.1 header). This simplified version hashes the raw key bytes,
    /// which is fine as long as you generate your pinned hash the SAME way.
    private func sha256Base64(_ data: Data) -> String {
        let digest = SHA256.hash(data: data)
        return Data(digest).base64EncodedString()
    }
}

// MARK: - Tip: print your server's hash once to fill in `pinnedKeyHashes`
//
// Temporarily replace the compare with:
//   print("PIN THIS:", serverKeyHash)
// run the app once against your real server, copy the printed value, then put it
// in `pinnedKeyHashes` and restore the real comparison.
