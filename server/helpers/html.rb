# frozen_string_literal: true

module SERVER
  # This is the page that will be displayed on the browser
  class HTML
    class << self
      def generate_body(svg_data)
        <<-HTML
        <!DOCTYPE html>
        <html>
          <head>
            <link rel="preconnect" href="https://fonts.googleapis.com">
            <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
            <link href="https://fonts.googleapis.com/css2?family=DM+Sans:ital,opsz,wght@0,9..40,100..1000;1,9..40,100..1000&family=Inter:ital,opsz,wght@0,14..32,100..900;1,14..32,100..900&display=swap" rel="stylesheet">
            <title>TOTP</title>
            <style>
            *,*::before,*::after{
            box-sizing: border-box;
            padding: 0;
            margin: 0;
            }

            h1 {
            font-family: "DM Sans", sans-serif;
            }

            body {
            font-family: "Inter", sans-serif;
            text-align: center;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            }
            </style>
          </head>
          <body>
            <div>
              <h2>1. Scan with Google Authenticator</h2>
              <div style="background: white; padding: 20px; display: inline-block; border-radius: 10px; box-shadow: 0 4px 8px rgba(0,0,0,0.1);">
              #{svg_data}
              </div>

              <h2>2. Enter the Code</h2>
              <form action="/verify" method="POST">
                <input type="text" name="code" placeholder="000000" maxlength="6" autocomplete="off"#{' '}
                  style="font-size: 24px; padding: 10px; width: 150px; text-align: center; letter-spacing: 5px;">
                <br><br>
                <button type="submit" style="font-size: 20px; padding: 10px 30px; cursor: pointer;">Verify</button>
              </form>
            </div>
          </body>
        </html>
        HTML
      end

      def generate_valid
        <<-HTML
        <body style="text-align: center; margin-top: 100px; font-family: sans-serif;">
        <h1 style='color: #2ecc71; font-size: 50px;'>SUCCESS!</h1>
        <p style='font-size: 20px;'>Your math perfectly matched Google's math for code <b>#{user_code}</b>.</p>
        <a href='/' style="font-size: 20px;">Try another</a>
        </body>
        HTML
      end

      def generate_invalid
        <<-HTML
        <body style="text-align: center; margin-top: 100px; font-family: sans-serif;">
        <h1 style='color: #e74c3c; font-size: 50px;'>FAILED</h1>
        <p style='font-size: 20px;'>The code <b>#{user_code}</b> is incorrect or expired.</p>
        <a href='/' style="font-size: 20px;">Try again</a>
        </body>
        HTML
      end
    end
  end
end
