//
//  xmlrpc_QuicktateAppDelegate.h
//  xmlrpc-Quicktate
//
//  Created by macpocket1 on 16/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class xmlrpc_QuicktateViewController;

@interface xmlrpc_QuicktateAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet xmlrpc_QuicktateViewController *viewController;

@end
