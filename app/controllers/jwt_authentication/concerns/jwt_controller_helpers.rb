module JwtAuthentication
  module Concerns
    module JwtControllerHelpers
      extend ActiveSupport::Concern

      included do
        skip_before_action :verify_authenticity_token, raise: false  # to avoid Devise check anti forgery token
        skip_before_action :verify_signed_out_user, raise: false  # we do it by ourselves
        before_action :allow_params_authentication!
        before_action :set_request_format!
      end

      def render_resource_or_errors(resource, options = {})
        if resource.errors.empty?
          render options.merge({ json: { resource: resource } })
        else
          render_errors resource.errors
        end
      end

      def json_status(bool)
        bool ? :ok : :unprocessable_entity
      end

      def require_no_authentication
      end

      def set_request_format!
        request.format = :json
      end

      def render_errors(errors)
        status = json_status !JwtAuthentication.status_error_in_response
        render json: { errors: errors }, status: status
      end
    end
  end
end
