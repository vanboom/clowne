require 'rspec/expectations'

RSpec.describe Clowne::Cloner do
  class SomeCloner < described_class
    adapter FakeAdapter

    include_all

    include_association :comments
    include_association :posts, :some_scope, clone_with: 'AnotherClonerClass'

    exclude_association :users

    nullify :title, :description

    finalize do |_source, _record, _params|
      1 + 1
    end
  end

  matcher :be_a_declaration do |declaration_class, values|
    match do |actual|
      expect(actual).to be_a(declaration_class)
      values.each do |field, value|
        actual_value = actual.public_send(field)
        if value.is_a?(Proc)
          expect(actual_value.call).to eq(value.call)
        else
          expect(actual_value).to eq(value)
        end
      end
    end
  end

  describe 'DSL and Configuration' do
    it 'configure cloner' do
      expect(SomeCloner.adapter).to eq(FakeAdapter)
      expect(SomeCloner.config).to be_a(Clowne::Configuration)

      config = SomeCloner.config.config
      expect(config[0]).to be_a(Clowne::Declarations::IncludeAll)

      expect(config[1]).to be_a_declaration(
        Clowne::Declarations::IncludeAssociation,
        {name: :comments, scope: nil, options: {}}
      )

      expect(config[2]).to be_a_declaration(
        Clowne::Declarations::IncludeAssociation,
        {name: :posts, scope: :some_scope, options: {clone_with: 'AnotherClonerClass'}}
      )

      expect(config[3]).to be_a_declaration(
        Clowne::Declarations::ExcludeAssociation, {name: :users}
      )

      expect(config[4]).to be_a_declaration(
        Clowne::Declarations::Nullify, {attributes: [:title, :description]}
      )

      expect(config[5]).to be_a_declaration(
        Clowne::Declarations::Finalize, {block: Proc.new { 1 + 1} }
      )
    end
  end
end
