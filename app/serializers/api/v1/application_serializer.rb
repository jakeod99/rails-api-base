module Api
  module V1
    class ApplicationSerializer
      include JSONAPI::Serializer

      def data
        serializable_hash[:data]
      end
    end
  end
end
