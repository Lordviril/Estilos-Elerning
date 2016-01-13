//
//  downloadManager.h
//  SalesApp
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"

@class ASINetworkQueue;

@protocol downloadManagerDelegate

- (void) didDownload:(BOOL)isComplete;
@end

@interface downloadManager : UIViewController 
{
	IBOutlet UILabel *lblStatus;
	UIProgressView *progressView;
	
	ASINetworkQueue *networkQueue;
	NSMutableArray *arAssets;
	BOOL failed;	
	id <downloadManagerDelegate> delegate;
	NSString *pdfName;
	int fileDownload;
	int request_Count;
}

@property (nonatomic, retain) IBOutlet UIProgressView *progressView;
@property (nonatomic, retain) id <downloadManagerDelegate> delegate;
-(id)initwithStringArray:(NSArray*)_stringArray PdfName:(NSString*)_pdfName;
- (void)imageFetchComplete:(ASIHTTPRequest *)request;
- (void)imageFetchFailed:(ASIHTTPRequest *)request;
-(NSString *) GetPath:(NSString *)Path;
@end
