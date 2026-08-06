# SSL / Certificate Pinning

**"SSL pinning" and "certificate pinning" are the same idea** (SSL is the old name for TLS): your app refuses to trust the server unless it presents a certificate (or public key) you've bundled into the app. This blocks man-in-the-middle attacks — even someone with a valid-but-rogue certificate can't intercept your traffic.

## The two flavors

| Flavor | You bundle | Pros | Cons |
|--------|-----------|------|------|
| **Certificate pinning** | The server's `.cer` file | Simple to understand | Breaks when the cert is renewed → must ship an app update |
| **Public-key pinning** | The public key (a hash) | Survives cert renewal (key usually stays) | Slightly more code |

Both are done by implementing **one `URLSessionDelegate` method**:
`urlSession(_:didReceive challenge:completionHandler:)`.

## Files (simple → advanced)

| Order | File | Level | What it does |
|-------|------|-------|--------------|
| 1 | [`CertificatePinning.swift`](./CertificatePinning.swift) | 🟢 Simple | Pin the server's certificate (compare bytes) — **start here** |
| 2 | [`PublicKeyPinning.swift`](./PublicKeyPinning.swift) | 🔴 Advanced | Pin the public key (survives cert renewal) |

## How it works (plain English)

```
App makes HTTPS request
      │
      ▼
Server sends its certificate  ─────►  URLSession asks your delegate:
                                       "Do you trust this certificate?"
      │                                        │
      │                                        ▼
      │                       You compare it to the one bundled in the app.
      │                                        │
      ▼                        match? ── yes ─► allow the connection
   connection                         └─ no ──► CANCEL (block the attacker)
```

## Setup steps

1. **Get the server's certificate.** In Terminal:
   ```
   openssl s_client -connect api.example.com:443 -showcerts </dev/null \
     | openssl x509 -outform DER -out example.cer
   ```
2. **Add `example.cer` to your Xcode project** (check "Copy items if needed", add to the app target).
3. **Use the pinned `URLSession`** from these files instead of `.shared`. Plug it into the `APIClient` from [../02-Networking](../02-Networking):
   ```swift
   let session = URLSession(configuration: .default,
                            delegate: CertificatePinningDelegate(),
                            delegateQueue: nil)
   let client = APIClient(baseURL: url, session: session)
   ```

## ⚠️ Important cautions

- **Certs expire / rotate.** If you pin a certificate and the server renews it, your app stops working until you ship an update. Pin the **public key** (or pin a long-lived CA cert), and pin **two** keys (current + backup).
- **Never disable validation** (`.performDefaultHandling` for everything, or trusting all certs) to "make it work" — that removes all security.
- Test that a wrong/rogue cert is actually **rejected**, not just that the happy path works.
