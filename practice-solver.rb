#!/usr/bin/env ruby
require 'set'

def get_max_pizza(pizzas, ingredients)
  i_max = 0
  sc_max = 0
  i = 0
  while i < pizzas.length
    break if sc_max >= pizzas[i].length - 1
    ing_i = pizzas[i][1..pizzas[i].length - 1]
    if (ing_i - ingredients.to_a).length > sc_max
      sc_max = (ing_i - ingredients.to_a).length
      i_max = i
    end
    i += 1
  end
#  p "i " + i.to_s
#  p "sc_max " + sc_max.to_s
#  p "ing " + pizzas[i_max][1..pizzas[i_max].length - 1].to_s
  return i_max
end

filename = ARGV[0]
file = File.open(filename)

meta_data_num = []

@meta_data = file.readline.split(' ')

@meta_data.each_with_index { |elem, i|
  meta_data_num[i] = elem.to_i
}

pizzas = []
x = 0
until file.eof?
  line = file.readline
  @pizza_ar = line.split(' ')
  p "new pizza " + x.to_s
  pizzas[x] = []
  @pizza_ar.each_with_index { |elem, i|
    pizzas[x][i] = x if i.zero?
    pizzas[x][i] = elem unless i.zero?
  }
  x += 1
end

p "sort pizzas..."
pizzas.sort_by!{ |p| -p.length }

fileout = File.open(filename.to_s.split('.in')[0] + ".out", "w+")

nb_teams = 0
nb_livraisons = [0,0,0]

while (!meta_data_num[3].zero? && meta_data_num[0] >= 4) || (!meta_data_num[2].zero? && meta_data_num[0] >= 2) || (!meta_data_num[1].zero? && meta_data_num[0] >= 2)
  p "teams of: 2>" + meta_data_num[1].to_s + " 3>" + meta_data_num[2].to_s + " 4>" + meta_data_num[3].to_s
  if !meta_data_num[3].zero?
    meta_data_num[3] -= 1
    meta_data_num[0] -= 4
    nb_livraisons[2] += 1
  elsif !meta_data_num[2].zero?
    meta_data_num[2] -= 1
    meta_data_num[0] -= 3
    nb_livraisons[1] += 1
  else
    meta_data_num[1] -= 1
    meta_data_num[0] -= 2
    nb_livraisons[0] += 1
  end
  nb_teams += 1
end

fileout.write(nb_teams.to_s + "\n")

until nb_teams.zero?
  if !nb_livraisons[2].zero?
    nb_pizzas = 4
    nb_livraisons[2] -= 1
  elsif !nb_livraisons[1].zero?
    nb_pizzas = 3
    nb_livraisons[1] -= 1
  else
    nb_pizzas = 2
    nb_livraisons[0] -= 1
  end
  fileout.write(nb_pizzas.to_s + " ")
  ingredients = Set.new
  until nb_pizzas.zero? || pizzas.length.zero?
    i_pizza = get_max_pizza(pizzas, ingredients)
    p "max pizza " + pizzas[i_pizza][0].to_s
    p "nb pizzas left " + pizzas.length.to_s
    p "nb pizzas in delivery left " + nb_pizzas.to_s
    p "nb teams left " + nb_teams.to_s
    ingredients.merge(pizzas[i_pizza][1..pizzas[i_pizza].length - 1])
#    p "ingredients " + ingredients.to_s
    fileout.write(pizzas[i_pizza][0].to_s)
    pizzas.delete_at(i_pizza)
    nb_pizzas -= 1
    if !nb_pizzas.zero?
      fileout.write(" ")
    else
      fileout.write("\n")
    end
  end
  ingredients = Set.new
  nb_teams -= 1
  p "---NEW TEAM---"
end
