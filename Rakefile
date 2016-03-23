NAME = "PageController"
WORKSPACE = "#{NAME}.xcworkspace"

SDK = "iphonesimulator9.2"
DESTINATION = "platform=iOS Simulator,name=iPhone 6,OS=9.2"

task :test do
  sh "xcodebuild clean -workspace #{WORKSPACE} -scheme #{NAME} -sdk #{SDK} -destination \"#{DESTINATION}\" build test | xcpretty -c"
end
