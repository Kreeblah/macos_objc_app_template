#import <AppKit/AppKit.h>
#import "ApplicationController.h"

int main(int argc, const char * argv[])
{
	@autoreleasepool
	{
		NSApplication* app = [NSApplication sharedApplication];
		ApplicationController* controller = [[ApplicationController alloc] init];
		[app setDelegate:controller];

		[app run];
	}

	return EXIT_SUCCESS;
}
