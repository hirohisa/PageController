NAME = "PageController"
WORKSPACE = "#{NAME}.xcworkspace"

task :test do
  sh "xcodebuild clean test -workspace #{WORKSPACE} -scheme #{NAME} -sdk iphonesimulator"
end
