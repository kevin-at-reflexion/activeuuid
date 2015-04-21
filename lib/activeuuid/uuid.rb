require 'uuidtools'

module UUIDTools
  class UUID
    alias_method :id, :raw

    def quoted_id
      s = raw.unpack("H*")[0]
      "x'#{s}'"
    end

    def as_json(options = nil)
      self.to_s
    end

    def to_param
      self.to_s
    end

    def self.serialize(value)
      case value
      when self, LazyUUID
        value
      when String
        LazyUUID.new value
      end
    end
  end
end

module Arel
  module Visitors
    class DepthFirst < Arel::Visitors::Visitor
      def visit_UUIDTools_UUID(o, a = nil)
        o.quoted_id
      end
    end

    class MySQL < Arel::Visitors::ToSql
      def visit_UUIDTools_UUID(o, a = nil)
        o.quoted_id
      end
    end

    class SQLite < Arel::Visitors::ToSql
      def visit_UUIDTools_UUID(o, a = nil)
        o.quoted_id
      end
    end

    class PostgreSQL < Arel::Visitors::ToSql
      def visit_UUIDTools_UUID(o, a = nil)
        "'#{o.to_s}'"
      end
    end
  end
end

module ActiveUUID
  module Attributes
    extend ActiveSupport::Concern

    included do
      singleton_class.alias_method_chain :instantiate, :uuid

      if self.uuid_columns.include? 'id'
        before_create :generate_id

        def self.primary_key
          'id'
        end

        def generate_id
          self.id = UUIDTools::UUID.random_create unless self.id?
        end
      end
    end

    module ClassMethods
      def instantiate_with_uuid(record, record_models = nil)
        uuid_columns.each do |uuid_column|
          record[uuid_column] = LazyUUID.serialize(record[uuid_column]) if record[uuid_column]
        end
        instantiate_without_uuid(record)
      end

      def uuid_columns
        @uuid_columns ||= columns.select { |c| c.type == :uuid }.map(&:name)
      end
    end
  end
end
