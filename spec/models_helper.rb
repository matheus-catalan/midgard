def self.partials
  partials_with_attributes = {}
  dirs.map do |root|
    partials = partials_list(root)
    dir = dir_split(root)

    partials_with_attributes = make_hierarchical_structure(dir, 0, partials, partials_with_attributes)
  end

  partials_with_attributes
end

def self.make_hierarchical_structure(dirs, index = 0, partials, structure)
  return if index >= dirs.length - 1

  structure[dirs[index].to_sym] =
    make_hierarchical_structure(dirs, index + 1, partials, structure[dirs[index].to_sym] || {})

  structure[dirs[index].to_sym] = partials if structure[dirs[index].to_sym].nil?

  structure
end

def dirs
  Dir.glob('./swagger/v1/components/**/*.json')
end

def dir_split(root)
  root&.slice!('./swagger/v1/components/')
  root&.slice!('.json')
  root&.split('/')
end

def partials_list(root)
  JSON.parse(File.read(root))
end
