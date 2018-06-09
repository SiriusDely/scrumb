require "rails_helper"

# Test suite for Scrum model
RSpec.describe Scrum, type: :model do
  # Association test
  # ensure Scrum model has a 1:m relationship with the Item model
  it { should have_many(:items).dependent(:destroy) }

  # Validation tests
  # ensure columns title and description are present before saving
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }
end
