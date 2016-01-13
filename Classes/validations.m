//
//  validations.m
//  Scanner
//
//  Created by hb3 on 30/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "validations.h"


@implementation validations

static eEducationAppDelegate *singletonObject = nil;


#pragma mark -
#pragma mark emailRegex to validate email address.

+ (BOOL) validateEmail: (NSString *) candidate error:(NSString**)error
{
	BOOL isValid = FALSE;
	if ([validations isValidData:candidate])
	{
		NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"; 
		NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex]; 	
		if (![emailTest evaluateWithObject:candidate])
		{
			*error = @"Invalid Email address."; 
			isValid = FALSE;
		}
		else 
		{
			isValid = TRUE;
			*error = @"";
		}
	}
	else 
	{
		*error = @"Invalid Email address.";
		isValid = FALSE;
	}
	return isValid;
}

#pragma mark -
#pragma mark Password validations

+ (BOOL) validatePasswordLength : (NSString*) PasswordValue error:(NSString**)error
{
	BOOL isValid = FALSE;
	if ([validations isValidData:PasswordValue])
	{
		if([PasswordValue length] < 4)
		{
			isValid = FALSE;
			*error = @"Password should be at least 4 characters long.";
		}
		else 
		{
			isValid = TRUE;
			*error = @"";
		}
	}
	else 
	{
		isValid = FALSE;
		*error = @"Password should not be blank.";
	}
	return isValid;
}

+ (BOOL) comparePasswords:(NSString*) password confirmPassword:(NSString*)confirmPassword
{
	return [password isEqualToString:confirmPassword];
}

#pragma mark - Instance of AppDelegate
+ (eEducationAppDelegate*) getAppDelegateInstance
{
	if (singletonObject == nil)
	{
		singletonObject = (eEducationAppDelegate*) [[UIApplication sharedApplication] delegate];
	}
	return singletonObject;
}

#pragma mark -
#pragma mark Blank value validations

+ (BOOL) isValidData : (NSString*) activeValue
{
	BOOL isValid = FALSE;
	if([[activeValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""] || activeValue == NULL)
	{
		isValid = FALSE;
	}
	else 
	{
		isValid = TRUE;
	}
	return isValid;
}

+(int)getNumberOfPages:(NSMutableArray*)array{
    int pages = array.count/2;
    if ((array.count%2)>0) {
        pages++;
    }
    return pages;
}

@end
