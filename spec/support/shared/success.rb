shared_examples_for "Success response" do
  it 'response should be success' do
    expect(response).to be_success
  end
end