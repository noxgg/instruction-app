//
//  SecondViewController.h
//  InstructionApp
//
//  Created by Guest Admin on 11/24/13.
//  Copyright (c) 2013 Scott Palomino. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SecondViewController : UIViewController{
    NSInteger imageIndex;
}
@property (weak, nonatomic) IBOutlet UIImageView *imageview2;
@property (nonatomic) NSInteger imageIndex;
@property (atomic,retain) UIImage *myImage;
- (IBAction)ViewBack:(id)sender;
@end
