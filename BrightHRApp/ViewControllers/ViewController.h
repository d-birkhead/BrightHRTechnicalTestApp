//
//  ViewController.h
//  BrightHRApp
//
//  Created by David Andrew Birkhead on 09/11/2017.
//  Copyright © 2017 David Birkhead. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTextField.h"
#import "ConnectionManager.h"

@interface ViewController : UIViewController <UITextFieldDelegate, NSURLSessionDelegate, NSURLSessionTaskDelegate, NSURLSessionDataDelegate>

@property (weak, nonatomic) IBOutlet CustomTextField *usernameTextField;
@property (weak, nonatomic) IBOutlet CustomTextField *passwordTextField;

// if button was used more than once, a custom class or category with predefined attributes may be a better option than using UIButton directly
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@property (strong, nonatomic) ConnectionManager *connectionManager;

- (IBAction)loginButtonPressed:(id)sender;

@end

