Pod::Spec.new do |s|
  s.name          = "SQLiteProtocol"
  s.version       = "0.1.0"
  s.summary       = "Basic database operations for swift and sqlite by making classes or structs conform to a protocol "

  s.homepage      = "https://github.com/dcb-ug/sqlite-protocol"
  s.license       = { :type => "MIT", :file => "LICENSE" }

  s.author        = { "Manuel Reich" => "mr@dcb.ug" }
  s.platform      = :ios
  s.platform      = :ios, "11.0"
  s.swift_version = "4.2"

  s.source        = { :git => "https://github.com/dcb-ug/sqlite-protocol.git", :tag => "#{s.version}" }

  s.source_files  = "Source/**/*.swift"
  s.dependency     "SQLite.swift", "~> 0.11.5"
end
