describe Api::V1::UserSerializer do
  let(:user) { FactoryBot.create(:user) }
  
  subject { Api::V1::UserSerializer.new(user) }

  before :each do
    @hash = subject.serializable_hash
  end
  
  it "responds with the expected format" do
    expect(@hash.keys).to eq([:data])
    expect(@hash[:data].keys.sort).to eq([:attributes, :id, :type])
    expect(@hash[:data][:attributes].keys).to eq([:username])
    expect(@hash[:data][:attributes][:username]).to eq(user.username)
    expect(@hash[:data][:id]).to eq(user.id.to_s)
    expect(@hash[:data][:type]).to eq(:user)
  end
end