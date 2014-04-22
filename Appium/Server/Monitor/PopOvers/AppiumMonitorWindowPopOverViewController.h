#import <Cocoa/Cocoa.h>

@interface AppiumMonitorWindowPopOverViewController : NSViewController<NSPopoverDelegate>

@property IBOutlet NSPopover *popover;

-(void) close;

@end
