//
//  xmlrpc_QuicktateViewController.m
//  xmlrpc-Quicktate
//
//  Created by macpocket1 on 16/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "xmlrpc_QuicktateViewController.h"
#import "Quicktate.h"

#define kUSER @"MYUSER"
#define kKEY @"MYPASS"

@implementation xmlrpc_QuicktateViewController

- (void)dealloc
{
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [Quicktate setCompletionBlock:^(id object, NSError *error, METHOD method) {
        NSLog(@"OBJECT :%@, ERROR: %@", object, [error description]);
        
        if (method == METHOD_CREATE)
        {
            [Quicktate getJobStatus:0 forAction:JOBACTION_CANCEL forUser:kUSER andKey:kKEY];
        }
    }];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"002-Vowels" ofType:@"mp3"];  
    NSData *data = [NSData dataWithContentsOfFile:filePath];  
    
    [Quicktate createQuicktateRequestWithUser:kUSER
                                          key:kKEY 
                                    audioData:data
                                     audioURL:nil 
                                     fileType:FILETYPE_MP3 
                                     language:LANGUAGETYPE_ES 
                                    timestamp:TIMESTAMP_OFF 
                                     metadata:@"this is metadata" 
                               callbackMethod:CALLBACKMETHOD_EMAIL 
                          callbackDestination:@"xxxx@gmail.com"];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
