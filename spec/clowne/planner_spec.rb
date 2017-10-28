RSpec.describe Clowne::Planner do
  describe 'compile' do
    let(:object) { double(reflections: {"users" => nil, "posts" => nil}) }

    subject { described_class.compile(cloner, object) }

    context 'when cloner with one included association' do
      let(:cloner) do
        Class.new(Clowne::Cloner) do
          adapter FakeAdapter
          include_association :users
        end
      end

      it { is_expected.to be_a_declarations([
        [ Clowne::Declarations::IncludeAssociation, {name: :users} ]
      ]) }
    end

    context 'when cloner with include_all declaration' do
      let(:cloner) do
        Class.new(Clowne::Cloner) do
          adapter FakeAdapter
          include_all
          include_association :users
        end
      end

      it { is_expected.to be_a_declarations([
        [ Clowne::Declarations::IncludeAssociation, {name: :users, options: {}} ],
        [ Clowne::Declarations::IncludeAssociation, {name: :posts} ]
      ]) }
    end

    context 'when cloner with include_all and redefined association' do
      let(:cloner) do
        Class.new(Clowne::Cloner) do
          adapter FakeAdapter
          include_all
          include_association :users, clone_with: 'AnotherCloner'
        end
      end

      it { is_expected.to be_a_declarations([
        [ Clowne::Declarations::IncludeAssociation, {name: :users, options: {clone_with: 'AnotherCloner'}} ],
        [ Clowne::Declarations::IncludeAssociation, {name: :posts} ]
      ]) }
    end
  end
end
