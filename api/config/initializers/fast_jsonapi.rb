# frozen_string_literal: true

module FastJsonapi
  module ObjectSerializer
    def flat_serializable_hash # rubocop:disable Metrics/MethodLength
      data = serializable_hash

      obj = if data.try(:[], :data).is_a?(Array)
              data.key?(:data) ? data[:data].map { flat_attributes(_1) } : []
            else
              data.key?(:data) ? flat_attributes(data[:data]) : {}
            end

      if data.try(:[], :meta).present?
        { data: obj, meta: data[:meta] }
      else
        obj
      end
    end

    def flat_serializable_hash_without_id
      flat_serializable_hash.except(:id)
    end

    def flat_attributes(json_api_object)
      return {} unless json_api_object&.key?(:id)

      {
        id: json_api_object.fetch(:id),
        **json_api_object.fetch(:attributes)
      }
    end
  end
end
