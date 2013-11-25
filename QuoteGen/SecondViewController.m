//
//  SecondViewController.m
//  InstructionApp
//
//  Created by Guest Admin on 11/24/13.
//  Copyright (c) 2013 Scott Palomino. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()

@end

@implementation SecondViewController
@synthesize imageIndex;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSArray *images= [[NSArray alloc] initWithObjects:
                      @"67.png",
                      @"68.png",
                      @"69.png",
                      @"70.png",
                      @"71.png",
                      @"72.png",
                      @"73.png",
                      @"74.png",
                      nil];
    
    NSLog(@"%ld",(long)imageIndex);
    _imageview2.image = [UIImage imageNamed:[images objectAtIndex:imageIndex]];
    [self.view bringSubviewToFront:_imageview2];
    // Do any additional setup after loading the view from its nib.
}
/*
id<ParentControllerDelegate> parent = (id)self.parentViewController;
NSAssert([parent conformsToProtocol:@protocol(ParentControllerDelegate)], @"Parent must conform to ParentControllerDelegate");

[parent popChildViewController:provideview];

*/
- (IBAction)ViewBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
