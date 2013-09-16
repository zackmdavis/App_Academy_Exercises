def set_add_el(set, el)
  set[el] = true
  set
end

def set_remove_el(set, el)
  set.delete(el)
  set
end

def set_list_els(set)
  set.keys
end

def set_member?(set, el)
  set[el] ? true : false
end

def set_union(set1, set2)
  set1.merge(set2)
end

def set_intersection(set1, set2)
  set1.select{|el, _| set2[el]}
end

def set_minus(set1, set2)
  set1.select{|el, _| !set2[el]}
end

my_set1 = {1 => true, 2 => true, 3 => true}
my_set2 = {3 => true, 4 => true, 5 => true}

p set_add_el(my_set1, 78)
p my_set1

set_remove_el(my_set1, 78)
p my_set1

p set_list_els(my_set1)

set_member?(my_set1, 1) # => true
set_member?(my_set2, 87) # => false

p set_union(my_set1, my_set2)
p my_set1

p set_intersection(my_set1,my_set2)
p set_minus(my_set1,my_set2)