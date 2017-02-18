require 'rails_helper'

# RSpec.describe User, type: :model do
#   pending "add some examples to (or delete) #{__FILE__}"
# end

require 'rails_helper'
RSpec.describe User do
  it 'requires a name' do
    user = User.new(name: '')
    user.valid?
    expect(user.errors[:name].any?).to eq(true)
  end
  it 'requires an email' do
    user = User.new(email: '')
    user.valid?
    expect(user.errors[:email].any?).to eq(true)
  end
  it 'accepts properly formatted email' do
    emails = ['kobe@lakers.com', 'kobe.bryant@lakers.com']
    emails.each do |email|
      user = User.new(email: email)
      user.valid?
      expect(user.errors[:email].any?).to eq(false)
    end
  end
  it 'rejects improperly formatted email' do
    emails = %w[@ user@ @example.com]
    emails.each do |email|
      user = User.new(email: email)
      user.valid?
      expect(user.errors[:email].any?).to eq(true)
    end
  end
  it 'requires a unique, case insensitive email address' do
    user1 = User.create(name:'kobe', email: 'kobe@lakers.com', password: 'password', password_confirmation: 'password')
    user2 = User.new(email: user1.email.upcase)
    user2.valid?
    expect(user2.errors[:email].first).to eq("has already been taken")
  end
  it 'requires a password' do
    user = User.new(password: '')
    user.valid?
    expect(user.errors[:password].any?).to eq(true)
  end
  it 'requires the password to match the password confirmation' do
    user = User.new(password: 'password', password_confirmation: 'not password')
    user.valid?
    expect(user.errors[:password_confirmation].first).to eq("doesn't match Password")
  end
  it 'automatically encrypts the password into the password_digest attribute' do
    user = User.create(name:'kobe', email: 'kobe@lakers.com', password: 'password', password_confirmation: 'password')
    expect(user.password_digest.present?).to eq(true)
  end
end
