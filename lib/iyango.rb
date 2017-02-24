

def pull_dog
  unhappy_dogs = ["https://goo.gl/zOm6Jl",
                  "https://goo.gl/AybH1b",
                  "https://goo.gl/SbYc9b",
                  "https://goo.gl/IZeYQ5",
                  "https://goo.gl/9kI2GL",
                  "https://goo.gl/su9t5b",
                  "https://goo.gl/BG4r3o",
                  "https://goo.gl/xrd7i2"
                  ]

  random_number = rand(7)
  return unhappy_dogs[random_number]
end
