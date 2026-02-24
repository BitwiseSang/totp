# frozen_string_literal: true

module SERVER
  # This is the page that will be displayed on the browser
  # rubocop: disable Metrics/ClassLength
  class HTML
    SHARED_STYLES = <<-CSS
      @import url('https://fonts.googleapis.com/css2?family=Space+Mono:ital,wght@0,400;0,700;1,400&family=Syne:wght@400..800&display=swap');

      *, *::before, *::after {
        box-sizing: border-box;
        padding: 0;
        margin: 0;
      }

      :root {
        --bg: #0a0c0f;
        --surface: #111419;
        --surface-2: #1a1f27;
        --border: #232830;
        --accent: #00ff88;
        --accent-dim: rgba(0, 255, 136, 0.12);
        --accent-glow: rgba(0, 255, 136, 0.35);
        --text: #e8edf5;
        --text-muted: #5a6272;
        --danger: #ff3b5c;
        --danger-dim: rgba(255, 59, 92, 0.12);
        --font-mono: 'Space Mono', monospace;
        --font-display: 'Syne', sans-serif;
      }

      # html, body {
      #   height: 100%;
      # }

      body {
        background-color: var(--bg);
        background-image:
          radial-gradient(ellipse 80% 50% at 50% -10%, rgba(0, 255, 136, 0.07), transparent),
          linear-gradient(180deg, transparent 70%, rgba(0, 255, 136, 0.02) 100%);
        color: var(--text);
        font-family: var(--font-mono);
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        min-height: 100vh;
        padding: 2rem;
      }
    CSS

    class << self
      def generate_body(svg_data)
        <<-HTML
        <!DOCTYPE html>
        <html lang="en">
          <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <link rel="preconnect" href="https://fonts.googleapis.com">
            <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
            <title>TOTP — Authenticator</title>
            <style>
            #{SHARED_STYLES}

            .card {
              width: 100%;
              max-width: 420px;
              background: var(--surface);
              border: 1px solid var(--border);
              border-radius: 16px;
              overflow: hidden;
              box-shadow:
                0 0 0 1px rgba(0,255,136,0.04),
                0 24px 64px rgba(0, 0, 0, 0.6),
                0 0 80px rgba(0, 255, 136, 0.04);
              animation: fadeUp 0.5s ease both;
            }

            @keyframes fadeUp {
              from { opacity: 0; transform: translateY(20px); }
              to   { opacity: 1; transform: translateY(0); }
            }

            .card-header {
              padding: 1.5rem 1.75rem 1.25rem;
              border-bottom: 1px solid var(--border);
              display: flex;
              align-items: center;
              gap: 0.75rem;
            }

            .shield-icon {
              width: 32px;
              height: 32px;
              color: var(--accent);
              flex-shrink: 0;
            }

            .header-text {
              display: flex;
              flex-direction: column;
              gap: 2px;
            }

            .app-title {
              font-family: var(--font-display);
              font-weight: 700;
              font-size: 1rem;
              letter-spacing: 0.08em;
              text-transform: uppercase;
              color: var(--text);
            }

            .app-subtitle {
              font-size: 0.65rem;
              color: var(--text-muted);
              letter-spacing: 0.05em;
            }

            .status-dot {
              width: 6px;
              height: 6px;
              border-radius: 50%;
              background: var(--accent);
              margin-left: auto;
              flex-shrink: 0;
              box-shadow: 0 0 8px var(--accent-glow);
              animation: pulse 2s ease-in-out infinite;
            }

            @keyframes pulse {
              0%, 100% { opacity: 1; }
              50% { opacity: 0.3; }
            }

            .card-body {
              padding: 1.75rem;
              display: flex;
              flex-direction: column;
              gap: 1.75rem;
            }

            .step {
              display: flex;
              flex-direction: column;
              gap: 0.875rem;
            }

            .step-label {
              display: flex;
              align-items: center;
              gap: 0.625rem;
              font-size: 0.7rem;
              font-weight: 700;
              letter-spacing: 0.12em;
              text-transform: uppercase;
              color: var(--text-muted);
            }

            .step-num {
              width: 18px;
              height: 18px;
              border-radius: 50%;
              border: 1px solid var(--accent);
              color: var(--accent);
              font-size: 0.6rem;
              display: flex;
              align-items: center;
              justify-content: center;
              flex-shrink: 0;
            }

            .qr-wrapper {
              background: #ffffff;
              border-radius: 10px;
              padding: 16px;
              display: flex;
              align-items: center;
              justify-content: center;
              width: fit-content;
              margin: 0 auto;
              box-shadow: 0 0 0 1px var(--border), 0 0 24px rgba(0,255,136,0.06);
            }

            .qr-wrapper svg {
              display: block;
            }

            .divider {
              height: 1px;
              background: var(--border);
            }

            .code-form {
              display: flex;
              flex-direction: column;
              gap: 1rem;
            }

            .input-group {
              position: relative;
            }

            .code-input {
              width: 100%;
              background: var(--surface-2);
              border: 1px solid var(--border);
              border-radius: 10px;
              color: var(--accent);
              font-family: var(--font-mono);
              font-size: 1.75rem;
              font-weight: 700;
              text-align: center;
              letter-spacing: 0.4em;
              padding: 0.875rem 1rem 0.875rem 2rem;
              outline: none;
              transition: border-color 0.2s, box-shadow 0.2s;
              caret-color: var(--accent);
            }

            .code-input::placeholder {
              color: var(--border);
              letter-spacing: 0.3em;
            }

            .code-input:focus {
              border-color: var(--accent);
              box-shadow: 0 0 0 3px var(--accent-dim), 0 0 16px var(--accent-dim);
            }

            .submit-btn {
              width: 100%;
              background: var(--accent);
              border: none;
              border-radius: 10px;
              color: #050806;
              font-family: var(--font-display);
              font-weight: 800;
              font-size: 0.85rem;
              letter-spacing: 0.1em;
              text-transform: uppercase;
              padding: 0.875rem;
              cursor: pointer;
              transition: opacity 0.15s, transform 0.15s, box-shadow 0.2s;
              box-shadow: 0 4px 20px rgba(0, 255, 136, 0.25);
            }

            .submit-btn:hover {
              opacity: 0.9;
              transform: translateY(-1px);
              box-shadow: 0 6px 28px rgba(0, 255, 136, 0.4);
            }

            .submit-btn:active {
              transform: translateY(0);
              opacity: 1;
            }

            .card-footer {
              padding: 0.875rem 1.75rem;
              border-top: 1px solid var(--border);
              font-size: 0.6rem;
              color: var(--text-muted);
              letter-spacing: 0.07em;
              text-align: center;
            }
            </style>
          </head>
          <body>
            <div class="card">
              <div class="card-header">
                <svg class="shield-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round">
                  <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/>
                  <path d="M9 12l2 2 4-4"/>
                </svg>
                <div class="header-text">
                  <span class="app-title">Authenticator</span>
                  <span class="app-subtitle">Two-factor verification</span>
                </div>
                <div class="status-dot"></div>
              </div>

              <div class="card-body">
                <div class="step">
                  <div class="step-label">
                    <span class="step-num">1</span>
                    Scan with Google Authenticator
                  </div>
                  <div class="qr-wrapper">
                    #{svg_data}
                  </div>
                </div>

                <div class="divider"></div>

                <div class="step">
                  <div class="step-label">
                    <span class="step-num">2</span>
                    Enter the 6-digit code
                  </div>
                  <form action="/verify" method="POST" class="code-form">
                    <div class="input-group">
                      <input
                        type="text"
                        name="code"
                        class="code-input"
                        placeholder="······"
                        maxlength="6"
                        autocomplete="off"
                        inputmode="numeric"
                        pattern="[0-9]*"
                      >
                    </div>
                    <button type="submit" class="submit-btn">Verify Identity</button>
                  </form>
                </div>
              </div>

              <div class="card-footer">
                Code refreshes every 30 seconds &nbsp;·&nbsp; Keep this page secure
              </div>
            </div>
          </body>
        </html>
        HTML
      end

      def generate_valid(user_code)
        <<-HTML
        <!DOCTYPE html>
        <html lang="en">
          <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <link rel="preconnect" href="https://fonts.googleapis.com">
            <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
            <title>Access Granted</title>
            <style>
            #{SHARED_STYLES}

            .result-card {
              max-width: 380px;
              width: 100%;
              background: var(--surface);
              border: 1px solid rgba(0, 255, 136, 0.25);
              border-radius: 16px;
              padding: 2.5rem 2rem;
              text-align: center;
              display: flex;
              flex-direction: column;
              align-items: center;
              gap: 1.25rem;
              box-shadow:
                0 0 0 1px rgba(0, 255, 136, 0.06),
                0 24px 64px rgba(0, 0, 0, 0.5),
                0 0 80px rgba(0, 255, 136, 0.08);
              animation: scaleIn 0.4s cubic-bezier(0.34, 1.56, 0.64, 1) both;
            }

            @keyframes scaleIn {
              from { opacity: 0; transform: scale(0.9); }
              to   { opacity: 1; transform: scale(1); }
            }

            .icon-ring {
              width: 72px;
              height: 72px;
              border-radius: 50%;
              background: var(--accent-dim);
              border: 2px solid var(--accent);
              display: flex;
              align-items: center;
              justify-content: center;
              box-shadow: 0 0 32px var(--accent-glow);
              animation: glow 2s ease-in-out infinite;
            }

            @keyframes glow {
              0%, 100% { box-shadow: 0 0 20px var(--accent-glow); }
              50%       { box-shadow: 0 0 48px rgba(0, 255, 136, 0.5); }
            }

            .icon-ring svg {
              width: 32px;
              height: 32px;
              color: var(--accent);
            }

            .result-title {
              font-family: var(--font-display);
              font-weight: 800;
              font-size: 1.75rem;
              letter-spacing: 0.06em;
              color: var(--accent);
              text-transform: uppercase;
            }

            .result-message {
              font-size: 0.8rem;
              color: var(--text-muted);
              line-height: 1.6;
            }

            .code-badge {
              background: var(--accent-dim);
              border: 1px solid rgba(0, 255, 136, 0.3);
              border-radius: 6px;
              padding: 0.3em 0.75em;
              color: var(--accent);
              font-weight: 700;
              letter-spacing: 0.2em;
              font-size: 1.1rem;
            }

            .back-link {
              display: inline-flex;
              align-items: center;
              gap: 0.4rem;
              font-size: 0.7rem;
              letter-spacing: 0.1em;
              text-transform: uppercase;
              color: var(--text-muted);
              text-decoration: none;
              border: 1px solid var(--border);
              border-radius: 8px;
              padding: 0.6rem 1.2rem;
              margin-top: 0.5rem;
              transition: color 0.2s, border-color 0.2s;
            }

            .back-link:hover {
              color: var(--accent);
              border-color: var(--accent);
            }
            </style>
          </head>
          <body>
            <div class="result-card">
              <div class="icon-ring">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                  <polyline points="20 6 9 17 4 12"/>
                </svg>
              </div>
              <div class="result-title">Access Granted</div>
              <div class="result-message">
                Code <span class="code-badge">#{user_code}</span> verified successfully.
              </div>
              <a href="/" class="back-link">
                ← Try another
              </a>
            </div>
          </body>
        </html>
        HTML
      end

      def generate_invalid(user_code)
        <<-HTML
        <!DOCTYPE html>
        <html lang="en">
          <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <link rel="preconnect" href="https://fonts.googleapis.com">
            <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
            <title>Access Denied</title>
            <style>
            #{SHARED_STYLES}

            .result-card {
              max-width: 380px;
              width: 100%;
              background: var(--surface);
              border: 1px solid rgba(255, 59, 92, 0.25);
              border-radius: 16px;
              padding: 2.5rem 2rem;
              text-align: center;
              display: flex;
              flex-direction: column;
              align-items: center;
              gap: 1.25rem;
              box-shadow:
                0 0 0 1px rgba(255, 59, 92, 0.06),
                0 24px 64px rgba(0, 0, 0, 0.5),
                0 0 80px rgba(255, 59, 92, 0.07);
              animation: shake 0.5s cubic-bezier(.36,.07,.19,.97) both;
            }

            @keyframes shake {
              0%, 100% { transform: translateX(0); }
              15%  { transform: translateX(-8px); }
              30%  { transform: translateX(7px); }
              45%  { transform: translateX(-6px); }
              60%  { transform: translateX(5px); }
              75%  { transform: translateX(-3px); }
              90%  { transform: translateX(2px); }
            }

            .icon-ring {
              width: 72px;
              height: 72px;
              border-radius: 50%;
              background: var(--danger-dim);
              border: 2px solid var(--danger);
              display: flex;
              align-items: center;
              justify-content: center;
              box-shadow: 0 0 28px rgba(255, 59, 92, 0.25);
            }

            .icon-ring svg {
              width: 30px;
              height: 30px;
              color: var(--danger);
            }

            .result-title {
              font-family: var(--font-display);
              font-weight: 800;
              font-size: 1.75rem;
              letter-spacing: 0.06em;
              color: var(--danger);
              text-transform: uppercase;
            }

            .result-message {
              font-size: 0.8rem;
              color: var(--text-muted);
              line-height: 1.6;
            }

            .code-badge {
              background: var(--danger-dim);
              border: 1px solid rgba(255, 59, 92, 0.3);
              border-radius: 6px;
              padding: 0.3em 0.75em;
              color: var(--danger);
              font-weight: 700;
              letter-spacing: 0.2em;
              font-size: 1.1rem;
            }

            .back-link {
              display: inline-flex;
              align-items: center;
              gap: 0.4rem;
              font-size: 0.7rem;
              letter-spacing: 0.1em;
              text-transform: uppercase;
              color: var(--text-muted);
              text-decoration: none;
              border: 1px solid var(--border);
              border-radius: 8px;
              padding: 0.6rem 1.2rem;
              margin-top: 0.5rem;
              transition: color 0.2s, border-color 0.2s;
            }

            .back-link:hover {
              color: var(--danger);
              border-color: var(--danger);
            }
            </style>
          </head>
          <body>
            <div class="result-card">
              <div class="icon-ring">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                  <line x1="18" y1="6" x2="6" y2="18"/>
                  <line x1="6" y1="6" x2="18" y2="18"/>
                </svg>
              </div>
              <div class="result-title">Access Denied</div>
              <div class="result-message">
                Code <span class="code-badge">#{user_code}</span> is incorrect or expired.
              </div>
              <a href="/" class="back-link">
                ← Try again
              </a>
            </div>
          </body>
        </html>
        HTML
      end
    end
  end
  # rubocop: enable Metrics/ClassLength
end
