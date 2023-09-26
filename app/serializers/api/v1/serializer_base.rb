module Api
  module V1
    class SerializerBase
      include JSONAPI::Serializer

      def data
        serializable_hash[:data]
      end
    end
  end
end