Gem::Specification.new do |s|
  s.name = "meme-collector"
  s.version = "0.0.0"
  s.license = "GPL-3.0"
  s.summary = "Collect memes over a period using the Google Custom Search API and Imgur API for a design project."
  s.description = "Collect memes over a period using the Google Custom Search API and Imgur API for a design project. Meme-collector has been created for a desing project."
  s.authors = ["Huub de Beer"]
  s.email = "Huub@heerdebeer.org"
  s.homepage = "https://github.com/htdebeer/meme-collector"
  s.files = Dir.glob(File.join("lib", "**", "*.rb"))
  s.files += Dir.glob(File.join("bin", "**"))
  s.bindir = "bin"
  s.executables = ["meme-collector"]
  s.add_development_dependency "rubocop", "~> 0.46"
  s.add_runtime_dependency "sqlite3", "~> 1.3"
  s.add_runtime_dependency "sequel", "~> 4.40"
  s.add_runtime_dependency "sinatra", "~> 1.4"
  s.required_ruby_version = "~> 2.3"
end
