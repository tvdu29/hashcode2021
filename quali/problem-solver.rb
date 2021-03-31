#! /usr/bin/env ruby
require 'set'

def get_intersections(paths, streets, graph, inters)
  paths.each { |path|
    path.each_with_index { |st, i|
      p "looking at street " + st.to_s + " " + streets[st].to_s + " " + graph[streets[st][0]].to_s
      streets[st][2] += 1
      inters[graph[streets[st][0]][1]].add(st) unless i == path.length - 1
    }
  }
  inters.each_with_index { |e, i|
    inters[i] = e.to_a
  }
  p "streetlights " + inters.to_s
end

def get_timming(inters, streets, cycles)
  inters.each { |int|
    min_sc = Float::INFINITY
    min_st = ""
    int.each { |st|
      if min_sc > streets[st][2]
        min_sc = streets[st][2]
        min_st = st
      end
    }
    int.sort_by!{ |st| streets[st][2]}
    int.each { |st|
      streets[st][2] = ((streets[st][2] / min_sc).round > (cycles / cycles).round) ? (cycles / cycles).round : (streets[st][2] / min_sc)
    }
  }
end

filename = ARGV[0]
file = File.open(filename)

meta_data_num = []

@meta_data = file.readline.split(' ')

@meta_data.each_with_index { |elem, i|
  meta_data_num[i] = elem.to_i
}

p "meta " + meta_data_num.to_s

streets = Hash.new
graph = []

x = 0
while x < meta_data_num[2]
  @streets = file.readline.split(' ')
  streets[@streets[2].to_s] = [x, @streets[3].to_i, 0]
  graph[x] = [@streets[0].to_i, @streets[1].to_i]
  x += 1
end

p "streets " + streets.to_s
p "graph " + graph.to_s

paths = []

x = 0
while x < meta_data_num[3]
  @cars = file.readline.split(' ')
  paths[x] = []
  @cars.each_with_index{ |elem, i|
    paths[x][i - 1] = elem.to_s unless i.zero?
  }
  x += 1
end

p "paths " + paths.to_s

inters = Array.new(meta_data_num[1])
inters.each_with_index{ |e, i| inters[i] = Set.new}

get_intersections(paths, streets, graph, inters)

fileout = File.open(filename.to_s.split('.txt')[0] + ".out", "w+")

cpt = 0

inters.each{ |int| cpt += 1 unless int.empty? }

get_timming(inters, streets, meta_data_num[0])

fileout.write(cpt.to_s + "\n")
inters.each_with_index{ |int, i|
  unless int.empty?
    fileout.write(i.to_s + "\n")
    p "--- INTERSECTION " + i.to_s + "---"
    p int.to_s
    fileout.write(int.length.to_s + "\n")
    int.each{ |st|
      fileout.write(st + " " + streets[st][2].to_s + "\n")
    }
  end
}
