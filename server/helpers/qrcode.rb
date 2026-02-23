# frozen_string_literal: true

require 'rqrcode'

module SERVER
  # Generates the qrcode as an svg using rqrcode
  class QRCODE
    class << self
      def generate(uri)
        qrcode = RQRCode::QRCode.new(uri)
        qrcode.as_svg(
          color: :black,
          shape_rendering: 'crispEdges',
          module_size: 5,
          standalone: true,
          use_path: true
        )
      end
    end
  end
end
