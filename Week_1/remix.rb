def remix(drinks)
  alcohol = drinks.map { |drink| drink[0] }
  mixers = drinks.map { |drink| drink[1] }
  alcohol.shuffle!
  alcohol.zip(mixers)
end