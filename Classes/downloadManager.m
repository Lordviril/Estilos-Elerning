
#import "downloadManager.h"
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"
#import "VirtualLibrary.h"
#import "eEducationAppDelegate.h"
@implementation downloadManager

@synthesize progressView;
@synthesize delegate;

#pragma mark -
#pragma mark UIView cycle



-(id)initwithStringArray:(NSArray*)_stringArray PdfName:(NSString*)_pdfName{
	if ((self = [self init])){
		if (!networkQueue) {
			networkQueue = [[ASINetworkQueue alloc] init];
		}
		fileDownload=0;
		request_Count=0;
		failed = NO;
		pdfName=[[NSString alloc] initWithString:_pdfName];
		[networkQueue reset];
		[networkQueue setDownloadProgressDelegate:progressView];
		[networkQueue setRequestDidFinishSelector:@selector(imageFetchComplete:)];
		[networkQueue setRequestDidFailSelector:@selector(imageFetchFailed:)];
		[networkQueue setDelegate:self];	
		arAssets=[[NSMutableArray alloc] initWithArray:_stringArray];
		for(int i = 0; i < [arAssets count]; i++)
		{
			if([[arAssets objectAtIndex:i] length]==0){
				continue;
			}
			request_Count++;
//			NSLog(@"%@",[arAssets objectAtIndex:i]);
			NSURL *URL= [NSURL URLWithString: [[arAssets objectAtIndex:i] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
			ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:URL];
			[request setDelegate:self];
			if([[[[_stringArray objectAtIndex:i] componentsSeparatedByString:@"."] lastObject] isEqualToString:@"pdf"]){
				[request setDownloadDestinationPath:[[self GetPath:pdfName] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.pdf",[eEducationAppDelegate UniqueNameGeneratorFromUrl:[_stringArray objectAtIndex:i]]]]];			
			}else
			{
				[request setDownloadDestinationPath:[[self GetPath:pdfName] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4",[eEducationAppDelegate UniqueNameGeneratorFromUrl:[_stringArray objectAtIndex:i]]]]];			
			}
			[networkQueue addOperation:request];
		}
		[networkQueue go];
	}	
	return self;
}
#pragma mark -
#pragma mark ASIHTTPRequest delegate method

- (void)imageFetchComplete:(ASIHTTPRequest *)request
{
	fileDownload++;
	if(fileDownload==request_Count)
	{
		[delegate didDownload:YES];
	}
}

- (void)imageFetchFailed:(ASIHTTPRequest *)request
{
	if (!failed) 
	{
		if ([[request error] domain] != NetworkRequestErrorDomain || [[request error] code] != ASIRequestCancelledErrorType) 
		{
			UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:alertTitle message:[eEducationAppDelegate getLocalvalue:@"Failed to download data"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
			[alertView show];
		}
		failed = YES;
		[networkQueue cancelAllOperations];
		NSFileManager *fileManager = [NSFileManager defaultManager];
		[fileManager removeItemAtPath:[self GetPath:[[pdfName componentsSeparatedByString:@"."] objectAtIndex:0]] error:NULL];
		[delegate didDownload:NO];
	}
}

-(NSString *) GetPath:(NSString *)Path
{
	NSString *pathString=@"";
	
		pathString = [NSString stringWithFormat: @"/%@/PDFBOOKS/%@", [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex: 0], [[pdfName componentsSeparatedByString:@"."] objectAtIndex:0]];
		[[NSFileManager defaultManager] createDirectoryAtPath:pathString withIntermediateDirectories:NO attributes:NO error:nil];
	
	if(![[NSFileManager defaultManager] fileExistsAtPath:pathString])
	{
		[[NSFileManager defaultManager] createDirectoryAtPath:pathString withIntermediateDirectories:YES attributes:nil error:nil]; 
	}
	return pathString;
}


#pragma mark -
#pragma mark Memory Management

- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning];    
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)dealloc {
	[networkQueue release];networkQueue=nil;
	[arAssets release];arAssets=nil;
    [super dealloc];
}


@end
