NAME = "PageController"
WORKSPACE = "#{NAME}.xcworkspace"

DESTINATION = "platform=iOS Simulator,OS=10.2,name=iPhone 7"

task :test do
  sh "xcodebuild test -workspace #{WORKSPACE} -scheme #{NAME} -destination \"#{DESTINATION}\" -configuration Release ONLY_ACTIVE_ARCH=NO ENABLE_TESTABILITY=YES | xcpretty"
end
