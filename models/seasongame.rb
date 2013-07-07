class SeasonGame

  include DataMapper::Resource

  property :id,         Serial
  property :created_at, DateTime
  property :active,     Boolean
  property :sold,       Boolean
  property :used,       Boolean

  belongs_to :season
  belongs_to :game

end