class Garden
  attr_accessor :name

  def initialize(name:)
    @name = name
  end

  def plants
    Plant.all.select do |plant|
      plant.garden == self
    end
  end
end
