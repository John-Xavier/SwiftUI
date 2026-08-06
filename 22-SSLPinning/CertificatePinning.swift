//
//  CertificatePinning.swift
//  START HERE — pin the server's certificate.
//
//  Idea: bundle the server's .cer file in the app. On every HTTPS connection,
//  compare the certificate the server sends against the bundled one. If they
//  don't match byte-for-byte, cancel the connection.
//
//  Setup: add your server's certificate (e.g. "example.cer") to the app target.
//  See README.md for the openssl command to export it.
//

import Foundation

/// A URLSession delegate that only trusts a connection whose certificate
/// matches the one bundled in the app.
final class CertificatePinningDelegate: NSObject, URLSessionDelegate {

    /// The filename (without extension) of the .cer you added to the app.
    private let pinnedCertificateName = "example"

    func urlSession(
        _ session: URLSession,
        didReceive challenge: URLAuthenticationChallenge,
        completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void
    ) {
        // 1. Make sure this challenge is about the server's TLS certificate.
        guard challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust,
              let serverTrust = challenge.protectionSpace.serverTrust,
              let serverCertificate = certificate(from: serverTrust)
        else {
            // Not a server-trust challenge we handle → reject to be safe.
            completionHandler(.cancelAuthenticationChallenge, nil)
            return
        }

        // 2. The certificate the server actually sent, as raw bytes.
        let serverCertData = SecCertificateCopyData(serverCertificate) as Data

        // 3. The certificate we bundled in the app, as raw bytes.
        guard let localCertData = loadPinnedCertificateData() else {
            completionHandler(.cancelAuthenticationChallenge, nil)
            return
        }

        // 4. Compare. Equal bytes = genuine server → allow. Otherwise → block.
        if serverCertData == localCertData {
            completionHandler(.useCredential, URLCredential(trust: serverTrust))
        } else {
            completionHandler(.cancelAuthenticationChallenge, nil)   // possible MITM!
        }
    }

    // MARK: - Helpers

    /// The first (leaf) certificate the server presented.
    private func certificate(from trust: SecTrust) -> SecCertificate? {
        if #available(iOS 15.0, *) {
            return (SecTrustCopyCertificateChain(trust) as? [SecCertificate])?.first
        } else {
            return SecTrustGetCertificateAtIndex(trust, 0)
        }
    }

    /// Load the bundled .cer file's bytes.
    private func loadPinnedCertificateData() -> Data? {
        guard let url = Bundle.main.url(forResource: pinnedCertificateName, withExtension: "cer") else {
            return nil
        }
        return try? Data(contentsOf: url)
    }
}

// MARK: - Build a URLSession that uses the pinning delegate
//
//   let session = URLSession(
//       configuration: .default,
//       delegate: CertificatePinningDelegate(),
//       delegateQueue: nil
//   )
//   // Then pass `session` into the APIClient from ../02-Networking:
//   let client = APIClient(baseURL: myURL, session: session)
