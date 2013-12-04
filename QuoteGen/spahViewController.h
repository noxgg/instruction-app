//
//  spahViewController.h
//  QuoteGen
//
//  Created by Scott Palomino on 11/22/13.
//  Copyright (c) 2013 Scott Palomino. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Slt/Slt.h>
#import <OpenEars/FliteController.h>
#import <OpenEars/LanguageModelGenerator.h>
#import <OpenEars/AcousticModel.h>
#import <OpenEars/PocketsphinxController.h>
#import <OpenEars/OpenEarsEventsObserver.h>

FliteController *fliteController;
Slt *slt;
PocketsphinxController *pocketsphinxController;
OpenEarsEventsObserver *openEarsEventsObserver;

@interface spahViewController : UIViewController <OpenEarsEventsObserverDelegate>
    @property (strong, nonatomic) FliteController *fliteController;
    @property (strong, nonatomic) Slt *slt;
    @property (nonatomic, strong) NSArray *instructions;
    @property (nonatomic, strong) NSArray *images;
    @property (nonatomic, strong) IBOutlet UITextView *currentInstruction;
    @property (nonatomic, strong) IBOutlet UIImageView *currentImage;
    @property (nonatomic) NSInteger instructionIndex;
    @property (nonatomic) NSInteger instructionCount;
    @property (strong, nonatomic) PocketsphinxController *pocketsphinxController;
    @property (strong, nonatomic) OpenEarsEventsObserver *openEarsEventsObserver;
    @property (nonatomic) Boolean isVoiceEnabled;
    - (IBAction)goBack:(id)sender;
    - (IBAction)goForward:(id)sender;
    - (IBAction)swipeUp:(id) sender;
    - (IBAction)swipeDown:(id) sender;
@end
