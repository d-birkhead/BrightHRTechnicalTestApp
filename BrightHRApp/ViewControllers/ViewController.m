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
    
    _connectionManager = [[ConnectionManager alloc] init];

    // set textfield delegates
    _usernameTextField.delegate = self;
    _passwordTextField.delegate = self;
    // disable login button
    [self loginEnableCheck];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginButtonPressed:(id)sender {
    // remove text from login button
    [_loginButton setTitle: @"" forState:UIControlStateNormal];

    // start activity indicator
    [_activityIndicator startAnimating];
    
    NSString *username = _usernameTextField.text;
    NSString *password = _passwordTextField.text;
    
    NSLog(@"User: %@, Pass: %@", username, password);
    
    [_connectionManager connectAndPostLogin:username :password];
}

- (void)viewDidAppear:(BOOL)animated{
    // listen for notifications from NSURLSessionDelegate
    [[NSNotificationCenter defaultCenter] addObserver:self
                                              selector:@selector(displayMessage:)
                                                  name:@"loginresponse"
                                                object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(displaySuccessMessage:)
                                                 name:@"logindata"
                                               object:nil];
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
    if ((_usernameTextField.text.length < 1)&&(_passwordTextField.text.length < 1)) {
        // disable login button
        _loginButton.enabled = NO;
        [_loginButton setBackgroundColor: [UIColor colorWithRed:0.68 green:0.05 blue:0.69 alpha:1.0]];
        [_loginButton setTitleColor: [UIColor colorWithRed:0.75 green:0.73 blue:0.76 alpha:1.0] forState: UIControlStateDisabled];
    }
}

- (void)displayMessage:(NSNotification *)notificationResponse{
    
    NSNumber *statusCode = [[notificationResponse userInfo] valueForKey:@"statuscode"];
    NSLog(@"Received Notification - status code: %@", statusCode);
    
    NSString *status = [NSString stringWithFormat:@"%@", statusCode];
    // if status contains successful login return code 200
    if ([status containsString: @"200"]) {
        NSLog(@"200 response received");
        return;
    }
    // if status contains invalid username or password return code 403
    if ([status containsString: @"403"]) {
        NSString *invalidUserPassString = @"Please enter a valid username or password";
        [self displayNotification: invalidUserPassString];
        return;
    }
    // if status contains neither a successful 200 or a wrong credential code 403
    if ((![status containsString: @"200"])||(![status containsString: @"403"])) {
        NSString *unknownErrorString = @"Sorry, something has gone wrong. Please try again.";
        [self displayNotification: unknownErrorString];
    }
}

- (void)displayNotification:(NSString *)message{
    // set up notification message
    UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Alert"
                                                                  message:message
                                                           preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* OK = [UIAlertAction actionWithTitle:@"OK"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * action)
                         
    {
        // stop activity indicator
        [_activityIndicator stopAnimating];
        // replace text from login button
        [_loginButton setTitle: @"Login" forState:UIControlStateNormal];
    }];
    
    [alert addAction:OK];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)displaySuccessMessage:(NSNotification *)notificationData{

    NSLog(@"NotficationData: %@", notificationData);
    
    if ([notificationData.userInfo objectForKey:@"userTimeZoneName"]){
            NSString *timezoneString = [NSString stringWithFormat: @"Welcome to %@", [notificationData.userInfo objectForKey:@"userTimeZoneName"]];
            [self displayNotification:timezoneString];
    }
}

@end
