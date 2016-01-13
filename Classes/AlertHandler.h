//
//  AlertHandler.h
//  Court Finder
//
//  Created by hb hidden on 07/01/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AlertHandler : NSObject {

}
+(void)showAlertForProcess;
+(void)showAlertForProcesswithMessege:(NSString*)imessege;
+(void)hideAlert;
+(void)ShowMessageBoxWithTitle:(NSString*)strTitle Message:(NSString*)strMessage Button:(NSString*)strButtonTitle;
@end
