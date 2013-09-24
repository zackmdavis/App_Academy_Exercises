class Employee
  attr_accessor :name, :title, :salary, :boss

  def initialize(name, title, salary, boss = nil)
    @name = name
    @title = title
    @salary = salary
    @boss = boss
    boss.add_employee(self) unless boss.nil?
  end

  def bonus(multiplier)
    @salary * multiplier
  end

  def salaries
    @salary
  end
end

class Manager < Employee
  attr_accessor :subordinates

  def initialize(name, title, salary, boss = nil)
    super(name, title, salary, boss)
    @subordinates = []
  end

  def add_employee(employee)
    @subordinates.push(employee)
  end

  def salaries
    sum_of_salaries = 0
    @subordinates.each do |employee|
      sum_of_salaries += employee.salaries
    end
    sum_of_salaries
  end

  def bonus(multiplier)
    salaries * multiplier
  end
end

boss = Manager.new("Managing Guy", "Manager", 4)
a = Employee.new("John Smith", "Programmer", 3, boss)
b = Employee.new("John Doe", "Programmer", 3, boss)
c = Employee.new("John Rugby", "Programmer", 3, boss)
p boss.bonus(2)