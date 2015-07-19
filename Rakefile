NAME = "PageController"
WORKSPACE = "#{NAME}.xcworkspace"
DESTINATION = '"OS=8.4,name=iPhone 6"'

task :clean do
	sh "xcodebuild -workspace #{WORKSPACE} -scheme #{NAME} clean"
end

task :test do
  sh "xcodebuild -workspace #{WORKSPACE} -scheme #{NAME} test -destination #{DESTINATION}"
end
