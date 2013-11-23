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
    @property (nonatomic, strong) NSArray *myQuotes;
    @property (nonatomic, strong) NSMutableArray *movieQuotes;
    @property (nonatomic, strong) IBOutlet UITextView *quoteText;
    @property (nonatomic) NSInteger index;
    @property (strong, nonatomic) PocketsphinxController *pocketsphinxController;
    @property (strong, nonatomic) OpenEarsEventsObserver *openEarsEventsObserver;

    - (IBAction)goBack:(id)sender;
    - (IBAction)goForward:(id)sender;
@end
