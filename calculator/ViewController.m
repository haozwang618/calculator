//
//  ViewController.m
//  calculator
//
//  Created by Haozhu Wang on 9/6/12.
//  Copyright (c) 2012 Haozhu Wang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

STATE currentState;
CALCTYPE currentCALC;
double waitingNum;
NSNumberFormatter * formatter;
bool decimal = false;
bool hasDecimal = false;
int lastTag;
@implementation ViewController
@synthesize currentNumber;
@synthesize results;
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    currentState = NORMAL;
    formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [currentNumber setText:@"0"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)processNormalNumber:(int) tag
{
    if(lastTag == 15)
    {
        [currentNumber setText:@"0"];
    }
    
    if(currentState == EVAL)
    {
        [currentNumber setText:[NSString stringWithFormat:@"%d", tag]];
        currentState = EVAL_STG;
    }
    else
    {
        NSString * numberText = [currentNumber text];
        
        if((hasDecimal==false)&&(decimal == true))
        {
            [currentNumber setText:[NSString stringWithFormat:@"%@.", numberText]];
            numberText = [currentNumber text];
            hasDecimal = true;
        }
        
        if  (((tag ==0) && ([numberText isEqualToString:@"0"])) && ([numberText isEqualToString:@""]))
        {
            return;
        }
        else if([numberText isEqualToString:@"0"])
        {
            [currentNumber setText:[NSString stringWithFormat:@"%d",tag]];
        }
        else
        {
            [currentNumber setText:[NSString stringWithFormat:@"%@%d", numberText, tag]];
        }
    }
}

-(void)processEqualPressed
{
    if(currentState != EVAL_STG)
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"ERROR" message:@"please enter another number to calculate" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        double secondNumber = [[formatter numberFromString:[currentNumber text]] doubleValue];
        NSString* thisString = [NSString stringWithFormat:@"%f",waitingNum];
        double result;
        switch (currentCALC) {
            case ADD:
                result = waitingNum + secondNumber;
                thisString = [NSString stringWithFormat:@"%@ + %f = %f\n",thisString, secondNumber, result];
                break;
                
            case SUB:
                result = waitingNum - secondNumber;
                thisString = [NSString stringWithFormat:@"%@ - %f = %f\n",thisString, secondNumber, result];
                break;
            case MULT:
                result = waitingNum * secondNumber;
                thisString = [NSString stringWithFormat:@"%@ x %f = %f\n",thisString, secondNumber, result];
                break;
                
            case DIV:
                result = waitingNum / secondNumber;
                thisString = [NSString stringWithFormat:@"%@ / %f = %f\n",thisString, secondNumber, result];
                break;
        }
        currentState = NORMAL;
        [currentNumber setText:[NSString stringWithFormat:@"%f", result]];
        [results setText:[NSString stringWithFormat:@"%@%@", [results text], thisString]];
        decimal = false;
        hasDecimal = false;
    }
}


-(void)setCalculationType: (int)tag
{
    if(currentState == EVAL_STG)
    {
        [self processEqualPressed];
    }
    currentState = EVAL;
    switch (tag) {
        case 10:
            currentCALC = ADD;
            break;
        
        case 11:
            currentCALC = SUB;
            break;
            
        case 12:
            currentCALC = MULT;
            break;
        
        case 13:
            currentCALC = DIV;
        default:
            break;
    }
    waitingNum = [[formatter numberFromString:[currentNumber text]] doubleValue];
}


-(void)processButtonPress: (int) tag
{
    if((tag >= 0) && (tag <=9))
    {
        [self processNormalNumber:tag];
    }
    else if((tag >= 10) && (tag <= 13))
    {
        [self setCalculationType:tag];
    }
    else if(tag == 15)
    {
        [self processEqualPressed];
    }
    else if(tag == 14)
    {
        UIAlertView * alert =[[UIAlertView alloc] initWithTitle:@"clear History?" message:@"do you want to clear the history?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES",nil];
        
        [alert show];
    }
    else if(tag == 16)
    {
        currentState = NORMAL;
        waitingNum = 0;
        [currentNumber setText:@"0"];
    }
    else if(tag == -1)
    {
        if(!decimal)
        {
            decimal = true;
            hasDecimal = false;
        }
        else
        {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"ERROR" message:@"cannot have two points!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }
    
    lastTag = tag;
}

-(IBAction)buttonPress:(id)sender
{
    UIButton* btPressed = (UIButton*)sender;
    int tag = btPressed.tag;
    [self processButtonPress:tag];
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if([[alertView title] isEqualToString:@"clear History?"])
    {
        if(buttonIndex ==1)
        {
            [results setText:@""];
        }
    }
}

@end
