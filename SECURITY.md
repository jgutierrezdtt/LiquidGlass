<!--
  SECURITY.md — LiquidGlass Framework
  Standard: GitHub Security Policy Template + OpenSSF Security Policy Standard v1.0
  References:
    - https://docs.github.com/en/code-security/getting-started/adding-a-security-policy-to-your-repository
    - https://github.com/ossf/security-policies
    - https://securitytxt.org (RFC 9116)
-->

# Security Policy

## Standard Compliance

This document follows the **GitHub Security Policy Template** and the **OpenSSF (Open Source Security Foundation) Security Policy Standard v1.0**. It is also compatible with the `security.txt` format defined in **RFC 9116**.

---

## Supported Versions

Only the latest release of LiquidGlass receives security patches. Older versions are **not** supported and should be migrated to the current release.

| Version | Supported |
|---------|-----------|
| Latest (`main`) | ✅ Actively supported |
| All previous releases | ❌ Not supported |

> This framework is a UI component library that runs entirely on the client device. It does not operate network services, persist user data, or handle authentication credentials. The security surface is therefore scoped to **supply-chain integrity**, **build-time safety**, and **safe defaults in UI components**.

---

## Reporting a Vulnerability

**Do not open a public GitHub Issue to report a security vulnerability.** Public disclosure before a fix is available puts all consumers of this library at risk.

### Private Disclosure Channel

Report vulnerabilities **privately** by emailing:

```
security@liquidglass.private
```

Include the following information to help us triage and reproduce the issue:

| Field | Description |
|-------|-------------|
| **Summary** | A brief description of the vulnerability |
| **Component** | Affected file(s), class(es), or module(s) |
| **Type** | e.g., code injection, data leakage, supply-chain, DoS |
| **Steps to Reproduce** | Minimal reproducible example or proof-of-concept |
| **Impact** | What an attacker could achieve |
| **Suggested Fix** | Optional — your recommended remediation |
| **Disclosure Deadline** | Requested responsible-disclosure deadline (default: 90 days) |

Encrypt sensitive reports using the PGP key published at:

```
https://liquidglass.private/.well-known/security.txt
```

### Response Timeline

| Stage | Target |
|-------|--------|
| Acknowledgement | Within **2 business days** of receipt |
| Initial triage & severity assessment | Within **5 business days** |
| Patch delivered to reporter for review | Within **30 days** (critical) / **90 days** (all others) |
| Public advisory published | After patch release, coordinated with reporter |

We follow the **CERT/CC 90-day responsible disclosure** model. If a critical vulnerability requires more time to patch, we will notify the reporter and agree on an extension.

---

## Severity Classification

We use the **CVSS v3.1** base score to classify vulnerabilities:

| CVSS Score | Severity | Response SLA |
|------------|----------|-------------|
| 9.0 – 10.0 | Critical | 7 days |
| 7.0 – 8.9  | High     | 30 days |
| 4.0 – 6.9  | Medium   | 60 days |
| 0.1 – 3.9  | Low      | 90 days |

---

## Scope

### In Scope

- Code injection or unexpected code execution via public API surface
- Unsafe handling of user-supplied `LocalizedStringKey` or `String` values in components
- Supply-chain attacks (compromised dependencies, build scripts, or xcframework artifacts)
- Bypassing accessibility or privacy controls embedded in components
- Vulnerabilities in `Scripts/build-xcframework.sh` that could produce a tampered binary

### Out of Scope

- Vulnerabilities in Apple SDKs, Xcode, or the Swift compiler
- Theoretical vulnerabilities with no practical exploit path
- Bugs that do not have a security impact (report via normal issues)
- Apps built **using** this library that introduce their own vulnerabilities

---

## Security Design Principles

LiquidGlass is designed with the following security principles, aligned with **OWASP Secure Design Principles** and **Apple Platform Security**:

1. **No network I/O** — The framework never opens network connections. It contains no URLSession, WKWebView, or external resource fetching.
2. **No data persistence** — The framework writes nothing to disk, Keychain, UserDefaults, or iCloud.
3. **No logging of sensitive data** — `Logger` (from `os`) is the only permitted logging mechanism; `print()` is prohibited by code policy. No component logs user-supplied text.
4. **Input validation at system boundaries** — All user-facing text inputs (`LGTextField`) delegate storage to the consuming app via `Binding<String>`; the library never retains or inspects the value.
5. **Dependency isolation** — This framework has zero third-party dependencies. All code is first-party Swift/SwiftUI.
6. **Reproducible builds** — `BUILD_LIBRARY_FOR_DISTRIBUTION = YES` ensures the ABI-stable binary is reproducible from source.
7. **Principle of least privilege** — No capabilities, entitlements, or permissions are declared in the framework target itself.

---

## Known Security Limitations

| Limitation | Mitigation |
|------------|------------|
| Glass backgrounds may reveal content behind them under unusual conditions | Consumers must respect `\.accessibilityReduceTransparency` and supply opaque fallbacks — the framework provides `lgReduceTransparency` environment entry for this purpose |
| No binary signing verification at framework load time | Consumers should verify the XCFramework checksum against the release manifest before embedding |

---

## Bug Bounty

There is currently **no public bug bounty program** for this project. Security researchers who responsibly disclose vulnerabilities will be credited in the public advisory (with their permission).

---

## Contact

| Role | Contact |
|------|---------|
| Security disclosures | security@liquidglass.private |
| General maintainer | jesus.gutierrez@liquidglass.private |

---

*Last reviewed: April 2026*
