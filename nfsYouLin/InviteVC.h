//
//  InviteVC.h
//  nfsYouLin
//
//  Created by Macx on 16/8/31.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ContactsUI/ContactsUI.h>
#import "PhonesView.h"

#import <MessageUI/MessageUI.h>

@interface InviteVC : UIViewController<UITextFieldDelegate,CNContactPickerDelegate,PhonesDelegate,MFMessageComposeViewControllerDelegate>

@end
