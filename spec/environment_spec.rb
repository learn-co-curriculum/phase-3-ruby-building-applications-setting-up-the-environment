describe "environment.rb" do
  it "loads the code for the Garden and Plant classes" do
    expect { Garden }.not_to raise_error
    expect { Plant }.not_to raise_error
  end
end
