json.sessions do
  json.array! @sessions do |session|
    json.partial! session
  end
end
json.count_sessions @sessions.count
