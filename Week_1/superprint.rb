def super_print(string, options = {:times => 1, :upcase => false, :reverse => false})
  super_string = string*options[:times]
  super_string.upcase! if options[:upcase]
  super_string.reverse! if options[:reverse]
  super_string
end
