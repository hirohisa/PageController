NAME = PageController
WORKSPACE = $(NAME).xcworkspace

clean:
	xcodebuild \
		-workspace $(WORKSPACE) \
		-scheme $(NAME) \
		clean

test:
	xcodebuild \
		-workspace $(WORKSPACE) \
		-scheme $(NAME) test \
		-destination "OS=8.4,name=iPhone 6"

send-coverage:
	coveralls \
		-e PageControllerTests
