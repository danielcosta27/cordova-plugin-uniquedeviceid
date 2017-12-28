//
//  CDVUniqueDeviceID.m
//
//
//

#import "CDVUniqueDeviceID.h"
#import "UICKeyChainStore.h"

@implementation CDVUniqueDeviceID

-(void)get:(CDVInvokedUrlCommand*)command
{
    [self.commandDelegate runInBackground:^{
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *uuidUserDefaults = [defaults objectForKey:@"uuid_elogs"];
        
        NSString *uuid = [UICKeyChainStore stringForKey:@"uuid_elogs"];

        if ([uuid length] == 0) {
            uuid = nil;
        }

        if ( uuid && !uuidUserDefaults) {
            [defaults setObject:uuid forKey:@"uuid_elogs"];
            [defaults synchronize];
            
        }  else if ( !uuid && !uuidUserDefaults ) {
            NSString *uuidString = [[NSUUID UUID] UUIDString];
            
            [UICKeyChainStore setString:uuidString forKey:@"uuid_elogs"];
            
            [defaults setObject:uuidString forKey:@"uuid_elogs"];
            [defaults synchronize];
            
            uuid = [UICKeyChainStore stringForKey:@"uuid_elogs"];
            
        } else if ( ![uuid isEqualToString:uuidUserDefaults] ) {
            [UICKeyChainStore setString:uuidUserDefaults forKey:@"uuid_elogs"];
            uuid = [UICKeyChainStore stringForKey:@"uuid_elogs"];
        }

        CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:uuid];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
    }];
}

@end

