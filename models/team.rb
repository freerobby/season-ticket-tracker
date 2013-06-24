class Team

  include DataMapper::Resource

  property :id,         Serial
  property :name,       String
  property :stadium,    String
  property :city,       String
  property :state,      String
  property :created_at, DateTime

  has n, :seasons

end