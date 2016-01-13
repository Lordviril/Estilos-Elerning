
#import "myVariables.h"


@implementation myVariables

@synthesize deviceOrientation;
@synthesize isInternetAvailable;
@synthesize doAnswersPosted;

static myVariables *sharedInstance =nil;

+ (myVariables *)sharedInstance
{
    static myVariables *myInstance = nil;
    if (nil == myInstance) 
	{
        myInstance  = [[super allocWithZone:NULL] init];
        // initialize variables here
    }
    return myInstance;
}

+ (id)allocWithZone:(NSZone *)zone {	
	@synchronized(self) 
	{
		if (sharedInstance == nil) 
		{
			sharedInstance = [super allocWithZone:zone];
			return sharedInstance;
		}
	}
	
	return nil;
}

- (id)copyWithZone:(NSZone *)zone {	
	return self;	
}

- (id)retain {	
	return self;	
}

- (unsigned)retainCount {	
	return NSUIntegerMax;	
}

- (void)release {
	//do nothing
}

- (id)autorelease {
	
	return self;
	
}

@end
