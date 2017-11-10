//
//  ViewController.m
//  BrightHRApp
//
//  Created by David Andrew Birkhead on 09/11/2017.
//  Copyright © 2017 David Birkhead. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // set textfield delegates
    _usernameTextField.delegate = self;
    _passwordTextField.delegate = self;

    // disable login button
    [self loginEnableCheck];
    [self.connectionManager = [ConnectionManager alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginButtonPressed:(id)sender {
    NSString *username = _usernameTextField.text;
    NSString *password = _passwordTextField.text;

    NSLog(@"User: %@, Pass: %@", username, password);
    [self.connectionManager connectAndPostLogin:username :password];
}

- (void)viewDidLayoutSubviews{
    // set corner radius for login button to make rounded corners
    _loginButton.layer.cornerRadius = 5;
}
// textFieldShouldReturn configured to define behaviour when return button is pressed on keyboard
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == _usernameTextField) {
        [_usernameTextField resignFirstResponder];
        [_passwordTextField becomeFirstResponder];
    }
    if (textField == _passwordTextField) {
        [_passwordTextField resignFirstResponder];
    }
    // check if login button should be enabled or disabled
    [self loginEnableCheck];

    return NO;
}

// method to check if text is entered into both username and password fields, and if so, enable the login button and adjust colour to show state
- (void)loginEnableCheck{
    // if username and password are entered enable login button
    if ((_usernameTextField.text.length > 1)&&(_passwordTextField.text.length > 1)) {
        _loginButton.enabled = YES;
        _loginButton.backgroundColor = [UIColor colorWithRed:1.00 green:0.10 blue:0.64 alpha:1.0];
        [_loginButton setTitleColor: [UIColor whiteColor] forState: UIControlStateNormal];
    }
    else{
        // disable login button
        _loginButton.enabled = NO;
        [_loginButton setBackgroundColor: [UIColor colorWithRed:0.68 green:0.05 blue:0.69 alpha:1.0]];
        [_loginButton setTitleColor: [UIColor colorWithRed:0.75 green:0.73 blue:0.76 alpha:1.0] forState: UIControlStateDisabled];

    }
}

@end
