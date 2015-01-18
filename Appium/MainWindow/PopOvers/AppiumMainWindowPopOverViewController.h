#import <Cocoa/Cocoa.h>
#import "AppiumModel.h"

@interface AppiumMainWindowPopOverViewController : NSViewController<NSPopoverDelegate>

@property (readonly) AppiumModel *model;
@property IBOutlet NSPopover *popover;

-(void) close;

@end
