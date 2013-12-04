//
//  menuController.h
//  InstructionApp
//
//  Created by Scott Palomino on 12/1/13.
//  Copyright (c) 2013 Scott Palomino. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "spahViewController.h"
#import "InstructionSet.h"

@interface menuController : UIViewController
    @property (nonatomic, strong) IBOutlet UIScrollView *menuContainer;
    @property (nonatomic, strong) NSArray *instructions;
@end
