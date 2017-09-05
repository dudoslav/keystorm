require 'digest'

module V3
  module Auth
    class FederationController < ApplicationController
      include Auditable
      include Timestampable
      include TokenRespondable

      attr_reader :credentials

      after_action :audit_unscoped_token

      def oidc
        auth_response ::Auth::Oidc, 'OIDC'
      end

      def voms
        auth_response ::Auth::Voms, 'SSL', 'GRST'
      end

      private

      def auth_response(type, *filters)
        @credentials = type.unified_credentials(ENV.select { |name| name.start_with?(*filters) })
        headers[x_subject_token_header_key] = Utils::Tokenator.to_token(credentials.to_hash)
        respond_with token_response
      end

      def audit_unscoped_tokens
        Rails.configuration.x.audit.info "Unscoped token #{digest_response_token} (digest) " \
                                         "from IP #{request.remote_ip} " \
                                         "for credentials #{credentials}"
      end

      def digest_response_token
        Digest::SHA256.base64digest(headers[x_subject_token_header_key])
      end
    end
  end
end
