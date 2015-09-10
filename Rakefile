NAME = "PageController"
WORKSPACE = "#{NAME}.xcworkspace"

task :test do
  sh "xcodebuild -workspace #{WORKSPACE} -scheme #{NAME} clean test -sdk iphonesimulator"
end
