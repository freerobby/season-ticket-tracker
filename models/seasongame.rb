class SeasonGame

  include DataMapper::Resource

  property :id,         Serial
  property :created_at, DateTime
  property :active,     Boolean
  property :sold,       Boolean
  property :used,       Boolean

  belongs_to :season
  belongs_to :game
  has 1, :listing

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

    listing_data = Hash.new

    if not self.listing.nil?
      listing_data[:initial_price] = self.listing.initial_price
      listing_data[:source] = self.listing.source
      listing_data[:list_date] = self.listing.list_date
      listing_data[:sell_date] = self.listing.sell_date
      listing_data[:created_at] = self.listing.created_at
    end

    game_data[:listing] = listing_data

    game_data
  end

end