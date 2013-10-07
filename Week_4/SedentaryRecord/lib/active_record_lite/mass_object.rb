class MassObject
  def self.my_attr_accessible(*attributes)
    @attributes = attributes
    attributes.each do |attribute|
      attr_accessor attribute
    end
  end

  def self.attributes
    @attributes
  end

  def self.parse_all(results)
  end

  def initialize(params = {})
    params.each do |name, value|
      if self.class.attributes.include?(name.to_sym)
        self.send(name.to_s+"=", value)
      else
        raise "mass assignment to unregister attribute #{name}"
      end
    end
  end
end