class Object

  def my_attr_accessor(*vars)
    vars.each do |var|
      self.send(:define_method, var.to_s) do
        self.instance_variable_get("@"+var.to_s)
      end
      self.send(:define_method, var.to_s+"=") do |value|
        self.instance_variable_set("@"+var.to_s, value)
      end
    end
  end

end