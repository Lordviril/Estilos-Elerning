//
//  validations.h
//  Scanner
//
//  Created by hb3 on 30/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "eEducationAppDelegate.h"

@interface validations : NSObject
{

}

// Email Address validation
+ (BOOL) validateEmail: (NSString *) candidate error:(NSString**)error;
// Password validation
+ (BOOL) validatePasswordLength : (NSString*) PasswordValue error:(NSString**)error;
+ (BOOL) comparePasswords:(NSString*) password confirmPassword:(NSString*)confirmPassword;

// Validate data
+ (BOOL) isValidData : (NSString*) activeValue;
+(int)getNumberOfPages:(NSMutableArray*)array;

#pragma mark - Instance of AppDelegate
+ (eEducationAppDelegate*) getAppDelegateInstance;

@end
