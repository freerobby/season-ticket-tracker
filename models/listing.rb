class Listing

  include DataMapper::Resource

  property :id,             Serial
  property :initial_price,  Float
  property :source,         String
  property :list_date,      DateTime
  property :sell_date,      DateTime
  property :created_at,     DateTime
  property :is_active,      Boolean     # only one active listing per game

  belongs_to :season_game

end