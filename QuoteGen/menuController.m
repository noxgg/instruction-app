//
//  menuController.m
//  InstructionApp
//
//  Created by Scott Palomino on 12/1/13.
//  Copyright (c) 2013 Scott Palomino. All rights reserved.
//

#import "menuController.h"

@implementation menuController
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initializeInstructions];
    NSUInteger i;
    int xCoord=0;
    int yCoord=0;
    int buttonHeight=50;
    int buffer = 3;
    for (i = 0; i < self.instructions.count; i++)
    {
        
        InstructionSet *target = self.instructions[i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.tag = i;
        
        [button addTarget:self  action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
        [button setTitle:target.title forState:UIControlStateNormal];
        button.frame = CGRectMake(xCoord, yCoord, [[UIScreen mainScreen] bounds].size.width, buttonHeight);
        [self.menuContainer addSubview:button];
        yCoord += buttonHeight + buffer;
    }

}

- (void)initializeInstructions
{
    InstructionSet *is = [InstructionSet alloc];
    is.title = @"Tutorial";
    is.instructions = @[
                          @"Welecome to the Pocket Guides tutorial. Swipe left for the next instruction.",
                          @"You can also say, 'Next,' to go to the next instruction.",
                          @"Swipe right or say 'Previous' to return to the last instruction.",
                          @"You can say, 'Read Instructions' to hear each instruction read out loud.",
                          @"Instructions will continue to be read out loud until you say 'Stop'.",
                          @"Many instructions have images as well. Swipe up to switch to image mode, then swipe down to go back to text mode.",
                          @"If you have used the 'Read Instructions' command, you can say 'Repeat' to hear the current instruction again.",
                          @"Finally, to return to the main menu, swipe left from the first instruction, or swipe right from the last instruction. You can also say, 'Menu,' to return to the menu at any time."
                          ];
    is.images= [[NSArray alloc] initWithObjects:
                  @"doge.jpg",
                  @"doge.jpg",
                  @"doge.jpg",
                  @"doge.jpg",
                  @"doge.jpg",
                  @"doge.jpg",
                  @"doge.jpg",
                  @"doge.jpg",
                  nil];
    InstructionSet *cooking = [InstructionSet alloc];
    cooking.title = @"How to Make Cinnamon Ornaments";
    cooking.instructions = @[
                             @"You will need the following ingredients\n3/4 cup applesauce\n4 oz bottle cinnamon, ground",
                             @"Mix the applesauce and cinnamon together until it forms a stiff dough.",
                             @"Roll the dough out to 1/4\" thickness.",
                             @"Use Christmas shaped cookie cutters to cut out the shapes that you want. Pierce a small hole with a skewer at the top of each ornament to allow a ribbon or string to be fed through.",
                             @"Lay the ornaments out on a wire cooling rack to dry out. They need to sit on this for a few days, test each day to see how dry they are. It helps to turn them now and then.",
                             @"Decorate as wished. Use suitable paints, liquid glitter and cake decoration items as wished. Let dry.",
                             @"Feed through the string or ribbon that will allow the ornament to be hung.",
                             @"Hang on the tree or wherever you like.",
                             @"You're all done!",
                        ];
    cooking.images= [[NSArray alloc] initWithObjects:
                @"ornaments8.jpg",
                @"ornaments1.jpg",
                @"ornaments2.jpg",
                @"ornaments3.jpg",
                @"ornaments4.jpg",
                @"ornaments5.jpg",
                @"ornaments6.jpg",
                @"ornaments7.jpg",
                @"ornaments8.jpg",
                     nil];
    InstructionSet *fller1 = [InstructionSet alloc];
    fller1.title = @"How to make a million dollars";
    fller1.instructions = @[@"Nothing to see here."];
    fller1.images= [[NSArray alloc] initWithObjects:@"ornaments8.jpg",nil];
    InstructionSet *fller2 = [InstructionSet alloc];
    fller2.title = @"How to do something else";
    fller2.instructions = @[@"Nothing to see here."];
    fller2.images= [[NSArray alloc] initWithObjects:@"ornaments8.jpg",nil];
    InstructionSet *fller3 = [InstructionSet alloc];
    fller3.title = @"How to build a house";
    fller3.instructions = @[@"Nothing to see here."];
    fller3.images= [[NSArray alloc] initWithObjects:@"ornaments8.jpg",nil];
    InstructionSet *fller4 = [InstructionSet alloc];
    fller4.title = @"How to reach the speed of light";
    fller4.instructions = @[@"Nothing to see here."];
    fller4.images= [[NSArray alloc] initWithObjects:@"ornaments8.jpg",nil];

    self.instructions = [NSArray arrayWithObjects:is,cooking, fller1, fller2, fller3, fller4, nil];
}

- (IBAction)buttonClicked:(UIButton *)sender
{
    UIStoryboard *storyboard = self.storyboard;
    spahViewController *secView = [storyboard instantiateViewControllerWithIdentifier:@"spahViewController"];
    InstructionSet *target = self.instructions[sender.tag];
    secView.instructions = target.instructions;
    secView.images = target.images;
    [self.view addSubview:secView.view];
    [self presentViewController:secView animated:YES completion:nil];
}
@end
