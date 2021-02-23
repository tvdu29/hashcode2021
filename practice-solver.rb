#!/usr/bin/env ruby

filename = ARGV[0]
file = File.open(filename)

meta_data_num = []

@meta_data = file.readline.split(' ')

@meta_data.each_with_index { |elem, i|
  meta_data_num[i] = elem.to_i
}

pizzas = []
x = 0
line = file.readline
until file.eof? || line.nil?
  @pizza_ar = line.split(' ')
  p "new pizza\n"
  pizzas[x] = []
  @pizza_ar.each_with_index { |elem, i|
    pizzas[x][i] = elem.to_i if i.zero?
    pizzas[x][i] = elem unless i.zero?
  }
  x += 1
  line = file.readline
end

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

i_pizza = 0

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
  until nb_pizzas.zero?
    fileout.write(i_pizza.to_s)
    i_pizza += 1
    nb_pizzas -= 1
    unless nb_pizzas.zero?
      fileout.write(" ")
    else
      fileout.write("\n")
    end
  end
  nb_teams -= 1
end
