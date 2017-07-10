//
//  ViewController.m
//  csoundSynthesizer
//
//  Created by Nikhil Singh on 7/9/17.
//  Copyright © 2017 Nikhil Singh. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () {
    SIGTYPE sig;
    int vol;
    CsoundObj *csound;
    CsoundUI *csoundUI;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
     // Initialize instance variables, including CsoundObj and CsoundUI objects
    sig = SINTYPE;
    vol = 0.8;
    csound = [[CsoundObj alloc] init];
    csoundUI = [[CsoundUI alloc] initWithCsoundObj:csound];
    
    [csoundUI addSlider:_levelSlider forChannelName:@"amp"]; // Bind to a UISlider
    [csound play:[[NSBundle mainBundle] pathForResource:@"csoundSynth" ofType:@"csd"]]; // Play .csd
    
    self.keyboardView.keyboardDelegate = self;
    [self didSelectSigtype:_sinButton];
    [self levelChange:_levelSlider]; // Initialize slider properties
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark IBActions

- (IBAction)levelChange:(UISlider *)sender {
    UIColor *color = [UIColor colorWithHue:(1./3.) - (sender.value/3.) saturation:1 brightness:1 alpha:1];
    [sender setMinimumTrackTintColor:color];
}

// Show csound.github.io in an SFSafariViewController
- (IBAction)showSite:(id)sender {
    NSURL *csoundURL = [NSURL URLWithString:@"http://csound.github.io"];
    SFSafariViewController *safariVC = [[SFSafariViewController alloc] initWithURL:csoundURL];
    [self presentViewController:safariVC animated:YES completion:nil];
}

// sig is set according to which button is touched
- (IBAction)didSelectSigtype:(UIButton *)sender {
    // Set all other buttons to false, sender to true
    NSArray *buttons = [NSArray arrayWithObjects:_sinButton, _sawButton, _sqrButton, _triButton, nil];
    for(UIButton *button in buttons) {
        if(button == sender) {
            [button setSelected:YES];
        } else {
            [button setSelected:NO];
        }
    }
    
    // Set sig depending on identity of sender
    if(sender == _sinButton) {
        sig = SINTYPE;
    } else if(sender == _sawButton) {
        sig = SAWTYPE;
    } else if(sender == _sqrButton) {
        sig = SQRTYPE;
    } else {
        sig = TRITYPE;
    }
}

#pragma mark Keyboard delegate methods

-(void)keyDown:(CsoundVirtualKeyboard *)keybd keyNum:(int)keyNum {
    // Key released
    NSString *score = [NSString stringWithFormat:@"i1.%003d 0 -1 %d %d", keyNum+60, keyNum+60, (int)sig];
    [csound sendScore:score];
}

-(void)keyUp:(CsoundVirtualKeyboard *)keybd keyNum:(int)keyNum {
    // Key touched
    NSString *score = [NSString stringWithFormat:@"i-1.%003d 0 -1 %d %d", keyNum+60, keyNum+60, (int)sig];
    [csound sendScore:score];
}

@end
