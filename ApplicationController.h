#import <Cocoa/Cocoa.h>
#define APP_MENU_NSSTRING APP_MENU_STRING

@interface ApplicationController : NSObject <NSApplicationDelegate>
{
}

-(void) applicationDidFinishLaunching:(NSNotification*) aNotification;

-(void) applicationWillTerminate:(NSNotification*) aNotification;

-(bool) applicationShouldTerminateAfterLastWindowClosed:(NSApplication*) app;

@end