//
//  Quicktate.h
//  xmlrpc-Quicktate
//
//  Created by macpocket1 on 16/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#include <Foundation/Foundation.h>

typedef enum {
    METHOD_CREATE = 1,
    METHOD_GETSTATUS = 0
} METHOD;

typedef enum {
    FILETYPE_MP3 = 1,
    FILETYPE_WAV = 0
} FILETYPE;

typedef enum {
    LANGUAGETYPE_ES = 2,
    LANGUAGETYPE_EN = 1
} LANGUAGETYPE;

typedef enum {
    TIMESTAMP_ON = 1,
    TIMESTAMP_OFF = 0
} TIMESTAMP;

typedef enum {
    CALLBACKMETHOD_HTTPPOST = 0,
    CALLBACKMETHOD_EMAIL = 1,
    CALLBACKMETHOD_XMLRPC = 2
} CALLBACKMETHOD;

typedef enum {
    JOBACTION_GETSTATUS = 0,
    JOBACTION_CANCEL = 1,
} JOBACTION;

typedef void (^XMLRPCCALL)(id object, NSError *error, METHOD method);

@interface Quicktate : NSObject
{
    
}

+ (void)setCompletionBlock:(XMLRPCCALL)block;
+ (void)getJobStatus:(int)jobID forAction:(JOBACTION)action forUser:(NSString *)user andKey:(NSString *)key;
+ (void)createQuicktateRequestWithUser:(NSString *)user 
                                   key:(NSString *)key 
                             audioData:(NSData *)data 
                              audioURL:(NSURL *)url 
                              fileType:(FILETYPE)fileType
                              language:(LANGUAGETYPE)languageType 
                             timestamp:(TIMESTAMP)timestamp
                              metadata:(NSString *)metadata
                        callbackMethod:(CALLBACKMETHOD)callbackMethod
                   callbackDestination:(NSString *)callbackDestination;
@end
