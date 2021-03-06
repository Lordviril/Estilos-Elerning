//
//	ReaderDocument.m
//	Reader v2.1.0
//
//	Created by Julius Oklamcak on 2011-07-01.
//	Copyright © 2011 Julius Oklamcak. All rights reserved.
//
//	This work is being made available under a Creative Commons Attribution license:
//		«http://creativecommons.org/licenses/by/3.0/»
//	You are free to use this work and any derivatives of this work in personal and/or
//	commercial products and projects as long as the above copyright is maintained and
//	the original author is attributed.
//

#import "ReaderDocument.h"
#import "CGPDFDocument.h"
#import <fcntl.h>
#include <string.h> /* memset */
#include <unistd.h> /* close */

@implementation ReaderDocument

#pragma mark Properties

@synthesize fileDate = _fileDate;
@synthesize fileSize = _fileSize;
@synthesize pageCount = _pageCount;
@synthesize pageNumber = _pageNumber;
@synthesize lastOpen = _lastOpen;
@synthesize password = _password;
@dynamic fileName, fileURL;

#pragma mark ReaderDocument class methods


+ (NSString *)applicationPath
{

	NSArray *documentsPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);

	return [[documentsPaths objectAtIndex:0] stringByDeletingLastPathComponent]; // Strip "Documents" component
}

+ (NSString *)relativeFilePath:(NSString *)fullFilePath
{

	assert(fullFilePath != nil); // Ensure that the full file path is not nil

	NSString *applicationPath = [ReaderDocument applicationPath]; // Get the application path

	NSRange range = [fullFilePath rangeOfString:applicationPath]; // Look for the application path

	assert(range.location != NSNotFound); // Ensure that the application path is in the full file path

	return [fullFilePath stringByReplacingCharactersInRange:range withString:@""]; // Strip it out
}

+ (BOOL)isPDF:(NSString *)filePath
{
	BOOL state = NO;

	if (filePath != nil) // Must have a file path
	{
		const char *path = [filePath fileSystemRepresentation];

		int fd = open(path, O_RDONLY); // Open the file

		if (fd > 0) // We have a valid file descriptor
		{
			const unsigned char sig[4]; // File signature

			ssize_t len = read(fd, (void *)&sig, sizeof(sig));

			if (len == 4)
				if (sig[0] == '%')
					if (sig[1] == 'P')
						if (sig[2] == 'D')
							if (sig[3] == 'F')
								state = YES; 

			close(fd); // Close the file
		}
	}

	return state;
}

#pragma mark ReaderDocument instance methods

- (id)initWithFilePath:(NSString *)fullFilePath password:(NSString *)phrase
{
#ifdef DEBUGX
	NSLog(@"%s", __FUNCTION__);
#endif

	id object = nil;

	if ([ReaderDocument isPDF:fullFilePath] == YES) // File must exist
	{
		if ((self = [super init])) // First initialize the superclass object
		{
			_password = [phrase copy]; // Keep a copy of any document password

			_pageNumber = [[NSNumber numberWithInteger:1] retain]; // Start page 1

			_fileName = [[ReaderDocument relativeFilePath:fullFilePath] retain];

			CFURLRef docURLRef = (CFURLRef)[self fileURL]; // CFURLRef from NSURL

			CGPDFDocumentRef thePDFDocRef = CGPDFDocumentCreateX(docURLRef, _password);

			if (thePDFDocRef != NULL) // Get the number of pages in a document
			{
				NSInteger pageCount = CGPDFDocumentGetNumberOfPages(thePDFDocRef);

				_pageCount = [[NSNumber numberWithInteger:pageCount] retain];

				CGPDFDocumentRelease(thePDFDocRef); // Cleanup
			}
			else // Cupertino, we have a problem with the document...
			{
				NSAssert(NO, @"thePDFDocRef == NULL"); //abort();
			}

			_lastOpen = [[NSDate dateWithTimeIntervalSinceReferenceDate:0.0] retain];

			NSFileManager *fileManager = [[NSFileManager new] autorelease]; // File manager

			NSDictionary *fileAttributes = [fileManager attributesOfItemAtPath:fullFilePath error:NULL];

			_fileDate = [[fileAttributes objectForKey:NSFileModificationDate] retain]; // File date

			_fileSize = [[fileAttributes objectForKey:NSFileSize] retain]; // File size
			object = self; // Return an initialized ReaderDocument object
		}
	}

	return object;
}

- (id)initWithFilePath:(NSString *)fullFilePath password:(NSString *)phrase dictVideoInfo:(NSMutableArray*)_arrayVideoInfo
{
#ifdef DEBUGX
	NSLog(@"%s", __FUNCTION__);
#endif
	
	id object = nil;
	
	if ([ReaderDocument isPDF:fullFilePath] == YES) // File must exist
	{
		if ((self = [super init])) // First initialize the superclass object
		{
			_password = [phrase copy]; // Keep a copy of any document password
			
			_pageNumber = [[NSNumber numberWithInteger:1] retain]; // Start page 1
			
			_fileName = [[ReaderDocument relativeFilePath:fullFilePath] retain];
			
			CFURLRef docURLRef = (CFURLRef)[self fileURL]; // CFURLRef from NSURL
			
			CGPDFDocumentRef thePDFDocRef = CGPDFDocumentCreateX(docURLRef, _password);
			
			if (thePDFDocRef != NULL) // Get the number of pages in a document
			{
				NSInteger pageCount = CGPDFDocumentGetNumberOfPages(thePDFDocRef);
				
				_pageCount = [[NSNumber numberWithInteger:pageCount] retain];
				
				CGPDFDocumentRelease(thePDFDocRef); // Cleanup
			}
			else // Cupertino, we have a problem with the document...
			{
				NSAssert(NO, @"thePDFDocRef == NULL"); //abort();
			}
			
			_lastOpen = [[NSDate dateWithTimeIntervalSinceReferenceDate:0.0] retain];
			
			NSFileManager *fileManager = [[NSFileManager new] autorelease]; // File manager
			
			NSDictionary *fileAttributes = [fileManager attributesOfItemAtPath:fullFilePath error:NULL];
			
			_fileDate = [[fileAttributes objectForKey:NSFileModificationDate] retain]; // File date
			
			_fileSize = [[fileAttributes objectForKey:NSFileSize] retain]; // File size
			_videoInfo=[[NSMutableArray alloc]initWithArray:_arrayVideoInfo];
			object = self; // Return an initialized ReaderDocument object
		}
	}
	
	return object;
}


- (void)dealloc
{
#ifdef DEBUGX
	NSLog(@"%s", __FUNCTION__);
#endif

	[_fileURL release], _fileURL = nil;

	[_password release], _password = nil;

	[_fileName release], _fileName = nil;

	[_pageCount release], _pageCount = nil;

	[_pageNumber release], _pageNumber = nil;

	[_fileSize release], _fileSize = nil;

	[_fileDate release], _fileDate = nil;

	[_lastOpen release], _lastOpen = nil;

	[super dealloc];
}

- (NSString *)fileName
{
#ifdef DEBUGX
	NSLog(@"%s", __FUNCTION__);
#endif

	return [_fileName lastPathComponent];
}

- (NSURL *)fileURL
{
#ifdef DEBUGX
	NSLog(@"%s", __FUNCTION__);
#endif

	if (_fileURL == nil) // Create and keep the file URL the first time it is requested
	{
		NSString *fullFilePath = [[ReaderDocument applicationPath] stringByAppendingPathComponent:_fileName];

		_fileURL = [[NSURL alloc] initFileURLWithPath:fullFilePath isDirectory:NO]; // File URL from full file path
	}

	return _fileURL;
}

-(NSMutableDictionary*)_dictVideoInfo :(NSInteger)pageNo{
	
	//NSDictionary *tempDict =[_videoInfo filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"pageNO == %i",pageNo]];
	//NSDictionary *tempDict=[[[NSDictionary alloc] init]autorelease];
		for(int i=0;i<[_videoInfo count];i++){
			if(pageNo==[[[_videoInfo objectAtIndex:i] objectForKey:@"video_page"] intValue]){
				return [_videoInfo objectAtIndex:i];
			}			
		}
	return nil;
}

	
@end
