class SeasonGame

  include DataMapper::Resource

  property :id,         Serial
  property :created_at, DateTime
  property :active,     Boolean
  property :sold,       Boolean
  property :used,       Boolean

  belongs_to :season
  belongs_to :game
  has n, :listing

  def build_game_hash
    game_data = Hash.new

    game_data[:used] = self.used
    game_data[:sold] = self.sold
    game_data[:active] = self.active

    if self.game.nil?
      ## TODO: return error
      return game_data.to_json
    end

    game_data[:id] = self.game.id
    game_data[:opponent] = self.game.opponent
    game_data[:location] = self.game.location
    game_data[:description] = self.game.description
    game_data[:gametime] = self.game.gametime
    game_data[:created_at] = self.game.created_at

    listings = Array.new

    if not self.listing.nil? and not self.listing.empty?
      self.listing.each do |listing|
        listing_data = Hash.new

        listing_data[:id] = listing.id
        listing_data[:initial_price] = listing.initial_price
        listing_data[:source] = listing.source
        listing_data[:list_date] = listing.list_date
        listing_data[:sell_date] = listing.sell_date
        listing_data[:created_at] = listing.created_at
        listing_data[:is_active] = listing.is_active

        listings.push(listing_data)
      end
    end

    game_data[:listings] = listings

    game_data
  end

end