# 🛡️ Pure Ruby TOTP Authenticator

![homepage](./docs/images/homepage.png)

A fully hand-rolled, zero-dependency (for the core library) Time-Based One-Time
Password (TOTP) and HMAC-Based One-Time Password (HOTP) implementation in pure
Ruby.

This project was built from first principles to deeply understand the low-level
bitwise operations, cryptographic hashing, and protocol specifications defined
in **RFC 2104** (HMAC), **RFC 4226** (HOTP) and **RFC 6238** (TOTP). It includes
a lightweight `WEBrick` web server to demonstrate real-time integration with the
Google Authenticator app.

🎥 **Watch the Demo Video:**

![Demo](./docs/demo.mp4)

## ✨ Features

- **RFC Compliant:** Strict adherence to HOTP (RFC 4226) and TOTP (RFC 6238)
  standards.
- **Hand-Rolled Crypto:** Custom HMAC implementation utilizing manual bitwise
  shifts, dynamic truncation, and block-size padding.
- **Time Drift Support:** Configurable verification windows to account for
  network latency and unsynced clocks (e.g., checking `T-1`, `T`, and `T+1`).
- **Algorithm Agnostic:** Built to support SHA-1 (default), SHA-256, and SHA-512
  via dependency injection.
- **Timing Attack Resistant:** Utilizes `OpenSSL.fixed_length_secure_compare`
  for constant-time string comparison.
- **Zero Core Dependencies:** The core `lib/totp` library uses only standard
  Ruby. (`rqrcode` and `webrick` are used exclusively for the demo UI).

## 🚀 Getting Started

### Prerequisites

- Ruby 4.0.0
- Google Authenticator (or any standard TOTP app) installed on your mobile device.

### Installation

Clone the repository and install the UI dependencies:

```bash
git clone https://github.com/yourusername/ruby-totp-authenticator.git
cd ruby-totp-authenticator
bundle install

```

### Running the Server

Start the WEBrick server to launch the web interface:

```bash
ruby server/server.rb

```

Navigate to `http://localhost:8080` in your browser. Scan the generated QR code
with your Authenticator app, enter the 6-digit PIN, and verify your identity.

## 🧠 Under the Hood (Architecture)

The project is strictly divided into two domains: the **Cryptographic Library**
and the **Web Interface**.

### 1. The Core Library (`/lib`)

- **`HMAC`**: The engine. Handles raw byte manipulation, inner/outer padding
  (`0x36` and `0x5c`), and hashing passes without relying on external HMAC
  wrappers.
- **`HOTP`**: The primitive. Converts counters to 64-bit big-endian formats,
  executes the HMAC hash, and performs the dynamic truncation to extract a
  31-bit integer.
- **`TOTP::Generator`**: The protocol layer. Calculates time steps (Unix epoch
  divided by interval) and handles drift verification using constant-time
  comparison.

### 2. The Demo Server (`server.rb` & `/helpers`)

A modularized WEBrick server that generates `otpauth://` URIs, renders QR codes
via `rqrcode`, and serves a responsive, modern UI crafted with pure HTML/CSS.

## 💻 Usage Example

You can extract the `lib/` directory and use it in any Ruby project:

```ruby
require_relative 'lib/totp'

secret = "12345678901234567890"

# 1. Generate a code
code = TOTP::Generator.generate(secret)
puts "Current PIN: #{code}"

# 2. Verify a code (Strict)
TOTP::Generator.verified?(secret, "123456")

# 3. Verify a code (With a 1-window drift allowance for latency)
TOTP::Generator.verified?(secret, "123456", drift: 1)

# 4. Use a different algorithm (e.g., SHA-256, 8 digits)
TOTP::Generator.generate(secret, digest: Digest::SHA256.new, digits: 8)

```
