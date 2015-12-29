NAME = "PageController"
WORKSPACE = "#{NAME}.xcworkspace"

task :test do
  sh "xcodebuild clean -workspace #{WORKSPACE} -scheme #{NAME} -sdk iphonesimulator build test"
end
