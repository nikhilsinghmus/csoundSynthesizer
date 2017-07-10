//
//  ViewController.h
//  csoundSynthesizer
//
//  Created by Nikhil Singh on 7/9/17.
//  Copyright © 2017 Nikhil Singh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SafariServices/SafariServices.h>
#import "CsoundObj.h"
#import "CsoundUI.h"
#import "CsoundVirtualKeyboard.h"

typedef enum : NSUInteger {
    SINTYPE = 1,
    SAWTYPE = 2,
    SQRTYPE = 3,
    TRITYPE = 4,
} SIGTYPE;

@interface ViewController : UIViewController<CsoundVirtualKeyboardDelegate>

@property (strong, nonatomic) IBOutlet UIButton *sqrButton;
@property (strong, nonatomic) IBOutlet UIButton *sinButton;
@property (strong, nonatomic) IBOutlet UIButton *triButton;
@property (strong, nonatomic) IBOutlet UIButton *sawButton;

@property (strong, nonatomic) IBOutlet UISlider *levelSlider;

@property (strong, nonatomic) IBOutlet CsoundVirtualKeyboard *keyboardView;

@end

