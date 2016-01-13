
#import <Foundation/Foundation.h>

@interface myVariables : NSObject 
{
	UIDeviceOrientation deviceOrientation;
	bool isInternetAvailable;
	bool doAnswersPosted;
}
@property (nonatomic, readwrite) bool isInternetAvailable;
@property (nonatomic, readwrite) bool doAnswersPosted;
@property (nonatomic, readwrite) UIDeviceOrientation deviceOrientation;

+ (myVariables *)sharedInstance;

@end



