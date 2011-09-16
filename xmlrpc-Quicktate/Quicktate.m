//
//  Quicktate.m
//  xmlrpc-Quicktate
//
//  Created by macpocket1 on 16/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Quicktate.h"
#import "XMLRPCResponse.h"
#import "XMLRPCRequest.h"
#import "XMLRPCConnection.h"
#import "Base64.h"

static XMLRPCCALL completionBlock;

@interface Quicktate (Private)

#define kXMLRPCURL @"http://api.quicktate.com/api/xml-rpc"

+ (BOOL)isValidEmail:(NSString *)email;
+ (void)initCompletionBlock;

@end

@implementation Quicktate

- (id)init
{
    if (self == [super init])
    {
        
    }
    
    return self;
}

+ (void)createQuicktateRequestWithUser:(NSString *)user 
                                   key:(NSString *)key 
                             audioData:(NSData *)data 
                              audioURL:(NSURL *)url 
                              fileType:(FILETYPE)fileType
                              language:(LANGUAGETYPE)languageType 
                             timestamp:(TIMESTAMP)timestamp
                              metadata:(NSString *)metadata
                        callbackMethod:(CALLBACKMETHOD)callbackMethod
                   callbackDestination:(NSString *)callbackDestination
{
    if (([user isEqualToString:@""]) || ([key isEqualToString:@""]))
        @throw [NSException exceptionWithName:@"User or Key cannot be empty" reason:@"User or Key cannot be empty" userInfo:nil];
    
    if (((id)data == nil) && ([url absoluteString] == @""))
        @throw [NSException exceptionWithName:@"Empty URL parameter" reason:@"Empty URL parameter" userInfo:nil];
    
    if (((id)data != nil) && ((id)url != nil))
        @throw [NSException exceptionWithName:@"Data or URL Must be empty" reason:@"Empty URL parameter" userInfo:nil];

    NSString *server = kXMLRPCURL;

    XMLRPCRequest *requestQuicktate = [[XMLRPCRequest alloc] initWithHost:[NSURL URLWithString:server]];

    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setValue:user forKey:@"user"];
    [params setValue:key forKey:@"key"];
    [params setValue:((id)data != nil) ? [Base64 encode:data]: nil forKey:@"audiodata"];
    [params setValue:((id)url != nil) ? [url absoluteString]: nil forKey:@"audiourl"];
    [params setValue:[NSString stringWithFormat:@"%d", fileType] forKey:@"filetype"]; //wav o mp3
    [params setValue:[NSString stringWithFormat:@"%d", languageType] forKey:@"language_id"]; //1 for English, 2 for Spanish 
    [params setValue:[NSString stringWithFormat:@"%d", timestamp] forKey:@"timestamp"]; //int
    [params setValue:metadata forKey:@"metadata"];
    
    switch (callbackMethod)
    {
        case 1:
        {
            [params setValue:@"EMAIL" forKey:@"callbackmethod"];
            
            if ([Quicktate isValidEmail:callbackDestination])
                [params setValue:callbackDestination forKey:@"callbackdest"];
            else
                @throw [NSException exceptionWithName:@"Email NOT valid" reason:@"Email NOT valid" userInfo:nil];
            
            break;
        } 
        case 2:
        {
            if (callbackDestination == @"")
                @throw [NSException exceptionWithName:@"Callback destination NOT valid" reason:@"Email NOT valid" userInfo:nil];
            
            [params setValue:@"XMLRPC" forKey:@"callbackmethod"];
            [params setValue:callbackDestination forKey:@"callbackdest"];
            break;
        } 
        default:
            
            if (callbackDestination == @"")
                @throw [NSException exceptionWithName:@"Callback destination NOT valid" reason:@"Email NOT valid" userInfo:nil];
            
            [params setValue:@"HTTPPOST" forKey:@"callbackmethod"];
            [params setValue:callbackDestination forKey:@"callbackdest"];
            break;
    }

    [requestQuicktate setMethod:@"job.submit" withObjects:[NSArray arrayWithObject:params]];
    [params release];
    
    XMLRPCResponse *userInfoResponse = [XMLRPCConnection sendSynchronousXMLRPCRequest:requestQuicktate];
    
    [requestQuicktate release];

    //NSLog(@"%@", result);
    
    if([userInfoResponse isKindOfClass:[NSError class]]) 
    {
        completionBlock(nil, (NSError *)userInfoResponse, METHOD_CREATE);
    }
    else
    {
        id result = [userInfoResponse object];
        
        if (result == nil)
            completionBlock(@"", [NSError errorWithDomain:@"BAD JSON REQUEST ERROR" code:999 userInfo:nil], METHOD_CREATE);
        else
            completionBlock(result, nil, METHOD_CREATE);
    }
}

+ (void)getJobStatus:(int)jobID forAction:(JOBACTION)action forUser:(NSString *)user andKey:(NSString *)key
{
    if ((user == @"") || (key == @""))
        @throw [NSException exceptionWithName:@"User or Key cannot be empty" reason:@"User or Key cannot be empty" userInfo:nil];
    
    NSString *server = kXMLRPCURL;
    
    XMLRPCRequest *requestQuicktate = [[XMLRPCRequest alloc] initWithHost:[NSURL URLWithString:server]];
    
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setValue:user forKey:@"user"];
    [param setValue:key forKey:@"key"];
    [param setValue:[NSString stringWithFormat:@"%d", jobID] forKey:@"job_id"];
    
    [requestQuicktate setMethod:(action == 0) ? @"job.status" : @"job.cancel" withObjects:[NSArray arrayWithObject:param]];
    [param release];
    
    XMLRPCResponse *userInfoResponse = [XMLRPCConnection sendSynchronousXMLRPCRequest:requestQuicktate];

    [requestQuicktate release];

    //NSLog(@"%@", result);
    
    if([userInfoResponse isKindOfClass:[NSError class]]) 
    {
        completionBlock(nil, (NSError *)userInfoResponse, METHOD_GETSTATUS);
    }
    else
    {
        id result = [userInfoResponse object];
        
        if (result == nil)
            completionBlock(@"", [NSError errorWithDomain:@"BAD JSON REQUEST ERROR" code:999 userInfo:nil], METHOD_GETSTATUS);
        else
            completionBlock(result, nil, METHOD_GETSTATUS);
    }
}

+ (void)setCompletionBlock:(XMLRPCCALL)block
{
    completionBlock = nil;
    completionBlock = [block copy];
}

#pragma -
#pragma Utillity methods

+ (BOOL)isValidEmail:(NSString *)email
{
    NSString *emailRegEx =
    @"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
    @"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
    @"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
    @"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
    @"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
    @"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
    @"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
    
    NSPredicate *regExPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    BOOL myStringMatchesRegEx = [regExPredicate evaluateWithObject:[email lowercaseString]];
	
	return myStringMatchesRegEx;
}

@end