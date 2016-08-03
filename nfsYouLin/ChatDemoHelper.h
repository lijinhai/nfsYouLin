/************************************************************
 *  * Hyphenate CONFIDENTIAL
 * __________________
 * Copyright (C) 2016 Hyphenate Inc. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of Hyphenate Inc.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Hyphenate Inc.
 */

#import <Foundation/Foundation.h>

//#import "ConversationListController.h"
//#import "ContactListViewController.h"
//#import "MainViewController.h"
#import "ChatViewController.h"
#import "CallViewController.h"
#import "FriendsVC.h"
#import "DiscoveryTVC.h"
#import "FirstTabBarController.h"

#define kHaveUnreadAtMessage    @"kHaveAtMessage"
#define kAtYouMessage           1
#define kAtAllMessage           2
@interface ChatDemoHelper : NSObject <EMClientDelegate,EMChatManagerDelegate,EMContactManagerDelegate,EMGroupManagerDelegate,EMChatroomManagerDelegate,EMCallManagerDelegate>






//@property (nonatomic, weak) ContactListViewController *contactViewVC;
//
//@property (nonatomic, weak) ConversationListController *conversationListVC;
//
@property (nonatomic, weak) FriendsVC *friendVC;
@property (nonatomic, weak) FirstTabBarController *mainVC;
@property (nonatomic, weak) DiscoveryTVC *discoveryVC;

@property (nonatomic, weak) ChatViewController *chatVC;



@property (strong, nonatomic) EMCallSession *callSession;
@property (strong, nonatomic) CallViewController *callController;



+ (instancetype)shareHelper;

- (void)asyncPushOptions;

- (void)asyncGroupFromServer;

- (void)asyncConversationFromDB;



- (void)makeCallWithUsername:(NSString *)aUsername
                     isVideo:(BOOL)aIsVideo;

- (void)hangupCallWithReason:(EMCallEndReason)aReason;

- (void)answerCall;



@end
