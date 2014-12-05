class User < ActiveRecord::Base
  has_many :contacts, -> { order('first_name ASC, last_name ASC') }

  has_secure_password

  validates :username, presence: true, uniqueness: { case_sensitive: true }
  validates :password, length: { minimum: 8 }
  validates :name, length: { minimum: 2 }, allow_blank: true

  # returns user given correct password
  def self.authenticate(username, password)
    user = find_by_username(username)
    return user if user && user.authenticate(password)
  end

  # returns user given correct password
  def self.authenticate(username, password)
    user = find_by_username(username)
    return user if user && user.authenticate(password)
  end

  # saves users from google into db
  def self.from_omniauth(auth)
    where(provider_name: auth.provider, provider_uid: auth.uid).first_or_initialize.tap do |user|
      user.name = auth.info.name
      user.provider_name = auth.provider
      user.password = "through_#{auth.provider}"
      user.username = "#{auth.provider}_uid_#{auth.uid}"
      user.provider_uid = auth.uid
      user.oauth_token = auth.credentials.token
      user.oauth_expires_at = Time.at(auth.credentials.expires_at)
      user.save!
    end
  end

  # imports up to 50 contacts from user's google account and returns a parsed hash
  def self.get_google_contacts(user)
    uri = URI.parse("https://www.google.com/m8/feeds/contacts/default/full?oauth_token=#{user.oauth_token}&max-results=50&alt=json")

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    # You should use VERIFY_PEER in production
    http.verify_mode = OpenSSL::SSL::VERIFY_PEER
    request = Net::HTTP::Get.new(uri.request_uri)
    response = http.request(request)
    contacts = ActiveSupport::JSON.decode(response.body)

    parsed_contacts = []

    contacts['feed']['entry'].each do |contact|
      temp = {}
      name = contact['title']['$t'] if contact.has_key?('title')
      email = contact['gd$email'][0]['address'] if contact.has_key?('gd$email')
      phone = contact['gd$phoneNumber'][0]['$t'] if contact.has_key?('gd$phoneNumber')
      address = contact['gd$postalAddress'][0]['$t'] if contact.has_key?('gd$postalAddress')

      # try to parse name returned by google
      f_name = name.split[0] if name.present?
      l_name = name.split[1..-1].join(' ') if name.present?

      temp.merge!('first_name' => f_name || "")
      temp.merge!('last_name' => l_name || "")
      temp.merge!('email' => email.try(:downcase) || "")
      temp.merge!('phone' => phone || "")
      temp.merge!('structured_postal_address' => address || "")

      # only keep contact if it passes validations on this end, length at least 2
      parsed_contacts << temp if (temp['first_name'].present? &&
                                  temp['first_name'].length > 1 &&
                                  temp['last_name'].length > 1)
    end unless contacts['feed']['entry'].nil?

    parsed_contacts
  end

  # adds the parsed list of contacts for the given user
  def self.add_google_contacts(user, contact_list)
    contact_list.each do |entry|
      user.contacts.where(entry).first_or_initialize.tap do |contact|
        contact.first_name = entry['first_name']
        contact.last_name = entry['last_name']
        contact.email = entry['email']
        contact.phone = entry['phone']
        contact.structured_postal_address = entry['structured_postal_address']
        contact.save!
      end
    end
  end
end
