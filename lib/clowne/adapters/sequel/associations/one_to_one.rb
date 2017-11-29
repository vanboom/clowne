# frozen_string_literal: true

module Clowne
  module Adapters # :nodoc: all
    class Sequel
      module Associations
        class OneToOne < Base
          def call(record)
            child = association
            return record unless child
            warn '[Clowne] Has one association does not support scopes' unless scope.nil?

            child_clone = clone_one(child)
            child_clone[:"#{reflection[:key]}"] = nil
            record.__send__(:"#{association_name}_attributes=", clonable_attributes(child_clone))
            binding.pry
            #[6] pry(#<Clowne::Adapters::Sequel::Associations::OneToOne>)>
            # record.account_attributes = {title: "A", history_attributes: {some_stuff: "B"}}
            record
          end
        end
      end
    end
  end
end
