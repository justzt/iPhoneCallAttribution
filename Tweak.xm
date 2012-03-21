#import <SpringBoard/SpringBoard.h>
#import "MPIncomingPhoneCallController.h"
#import "NetworkMini.h"


NetworkMini *netMini;
%hook SpringBoard
-(void)applicationDidFinishLaunching:(id)application{
%orig;
    netMini = [[NetworkMini alloc] init];
}

%end

%hook SBUIFullscreenAlertAdapter
- (id)initWithAlertController:(id)arg1{
%orig;    
    MPIncomingPhoneCallController *phoneCall = (MPIncomingPhoneCallController*)arg1;
    if([phoneCall respondsToSelector:@selector(updateLCDWithName: label: breakPoint:)]){
        [netMini performSelector:@selector(modifyDefaultNumber:) withObject:phoneCall afterDelay:0.2];
    }
    return self;
}
%end

