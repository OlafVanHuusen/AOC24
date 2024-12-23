require 'aoc_utils'

def main
  connections_raw = AocUtils.read_strings('Day 23/input.txt')
  connections = connections_raw.map { |connection| connection[0].split("-") }
  nodes = find_nodes(connections)
  connections_hash = create_connections_hash(connections)
  cliques = find_cliques(nodes, connections_hash)
  biggest_clique = find_biggest_clique(cliques, connections_hash)
  puts biggest_clique.sort.join(",")
  puts cliques.length
end

def find_biggest_clique(cliques, connections_hash)
  cliques_old = cliques
  cliques_new = Set.new
  while cliques_old.length > 1
    cliques_old.each do |clique|
      new_candidates_arr = []
      clique.each do |clique_member|
        new_candidates_arr << connections_hash[clique_member]
      end
      new_candidates = new_candidates_arr.reduce { |a, b| a.intersection(b) }
      new_candidates.each do |new_candidate|
        new_clique = clique.clone
        new_clique << new_candidate
        cliques_new << new_clique
      end
    end
    cliques_old = cliques_new
    cliques_new = Set.new
  end
  cliques_old.first
end

def find_cliques(nodes, connections_hash)
  cliques = Set.new
  (0..nodes.length - 1).each do  |i|
    temp = connections_hash[nodes[i]]
    (0..temp.length - 1).each do |j|
      (0..temp.length - 1).each do |k|
        if j != k
          if connections_hash[temp[j]].include?(temp[k])
            #if nodes[i][0] == 't' || temp[j][0] == 't' || temp[k][0] == 't'
              cliques << Set.new([nodes[i], temp[j], temp[k]])
            #end
          end
        end
      end
    end
  end
  cliques
end

def create_connections_hash(connections)
  connections_hash = Hash.new { |hash, key| hash[key] = [] }
  connections.each do |connection|
    connections_hash[connection[0]] << connection[1]
    connections_hash[connection[1]] << connection[0]
  end
  connections_hash
end

def find_nodes(connections)
  nodes = []
  connections.each do |connection|
    nodes << connection[0]
    nodes << connection[1]
  end
  nodes.uniq
end

main