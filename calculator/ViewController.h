//
//  ViewController.h
//  calculator
//
//  Created by Haozhu Wang on 9/6/12.
//  Copyright (c) 2012 Haozhu Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
typedef enum _state {
    NORMAL = 0,
    EVAL = 10,
    EVAL_STG = 20,
    } STATE;

typedef enum _calc{
    ADD = 100,
    SUB = 200,
    MULT = 300,
    DIV = 400,
} CALCTYPE;

@interface ViewController : UIViewController<UIAlertViewDelegate>
@property(strong, nonatomic) IBOutlet UITextView * results;
@property (strong, nonatomic) IBOutlet UITextField * currentNumber;

-(IBAction)buttonPress:(id)sender;
@end
