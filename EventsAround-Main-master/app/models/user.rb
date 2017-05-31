class User < ApplicationRecord
  has_secure_password
  has_one :personalinfo;
  validates_format_of :name, :with => /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/, :message => '$Email Id is invalid$'
  validates :password, :presence => true,
                   :confirmation => true,
                   :length => {:within => 5..20, :message => '$Password length is very small$'};

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_initialize.tap do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.name = auth.info.name
      user.oauth_token = auth.credentials.token
      user.oauth_expires_at = Time.at(auth.credentials.expires_at)
      user.save!
    end
  end
                   
end
