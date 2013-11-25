//
//  spahViewController.m
//  QuoteGen
//
//  Created by Scott Palomino on 11/22/13.
//  Copyright (c) 2013 Scott Palomino. All rights reserved.
//

#import "spahViewController.h"

@interface spahViewController ()

@end

@implementation spahViewController
@synthesize fliteController;
@synthesize slt;
@synthesize pocketsphinxController;
@synthesize openEarsEventsObserver;


- (OpenEarsEventsObserver *)openEarsEventsObserver {
	if (openEarsEventsObserver == nil) {
		openEarsEventsObserver = [[OpenEarsEventsObserver alloc] init];
	}
	return openEarsEventsObserver;
}


- (PocketsphinxController *)pocketsphinxController {
	if (pocketsphinxController == nil) {
		pocketsphinxController = [[PocketsphinxController alloc] init];
	}
	return pocketsphinxController;
}

- (FliteController *)fliteController {
	if (fliteController == nil) {
		fliteController = [[FliteController alloc] init];
	}
	return fliteController;
}

- (Slt *)slt {
	if (slt == nil) {
		slt = [[Slt alloc] init];
	}
	return slt;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.index = 0;
	// Do any additional setup after loading the view, typically from a nib.
    self.myQuotes = @[
                      @"1hi",
                      @"2Don't cry over spilt milk",
                      @"3Always look on the bright side of life",
                      @"4Nobody's perfect",
                      @"5Can't see the woods for the trees",
                      @"6Better to have loved and lost then not loved at all",
                      @"7The early bird catches the worm",
                      @"8As slow as a wet week"
                      ];
    
    
    NSArray *words = [NSArray arrayWithObjects:@"PREVIOUS", @"NEXT", @"SHOW PHOTO", @"SHOW TEXT", nil];
    NSString *name = @"NameIWantForMyLanguageModelFiles";
    LanguageModelGenerator *lmGenerator = [[LanguageModelGenerator alloc] init];
    NSError *err = [lmGenerator generateLanguageModelFromArray:words withFilesNamed:name forAcousticModelAtPath:[AcousticModel pathToModel:@"AcousticModelEnglish"]];
    
    NSDictionary *languageGeneratorResults = nil;
    
    NSString *lmPath = nil;
    NSString *dicPath = nil;
	
    if([err code] == noErr) {
        
        languageGeneratorResults = [err userInfo];
		
        lmPath = [languageGeneratorResults objectForKey:@"LMPath"];
        dicPath = [languageGeneratorResults objectForKey:@"DictionaryPath"];
		
    } else {
        NSLog(@"Error: %@",[err localizedDescription]);
    }
    
    
    [self.pocketsphinxController startListeningWithLanguageModelAtPath:lmPath dictionaryAtPath:dicPath acousticModelAtPath:[AcousticModel pathToModel:@"AcousticModelEnglish"] languageModelIsJSGF:NO];
    
    [self.openEarsEventsObserver setDelegate:self];
    
   
     _GestureRecognizers = [[NSMutableArray alloc] init];
    UISwipeGestureRecognizer *swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(SwipeUp:)];
    swipeRecognizer.direction = UISwipeGestureRecognizerDirectionUp;
      [_GestureRecognizers addObject:swipeRecognizer];
    [self.view addGestureRecognizer:swipeRecognizer];

    
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)SwipeUp:(UIGestureRecognizer *) sender{
    // Open new view
    NSLog(@"swiped");
  
    
   // if (sender.state == UIGestureRecognizerStateEnded)
    //{
         UIStoryboard *storyboard = self.storyboard;
        
         secView = [storyboard instantiateViewControllerWithIdentifier:@"SecondViewController"];
        int array_tot = [self.myQuotes count];
        int ind = (self.index % array_tot);
        secView.imageIndex = ind;
        [self.view addSubview:secView.view];
        [self presentViewController:secView animated:YES completion:nil];
    //}    
}

   


-(IBAction)goBack:(id)sender {
    // 1 - Get number of rows in array
    int array_tot = [self.myQuotes count];
    // 2 - Get random index
    self.index--;
    int ind = (self.index % array_tot);
    // 3 - Get the quote string for the index
    NSString *my_quote = self.myQuotes[ind];
    // 4 - Display the quote in the text view
    self.quoteText.text = [NSString stringWithFormat:@"Quote:\n\n%@",  my_quote];
    [self.fliteController say:my_quote withVoice:self.slt];
}

-(IBAction)goForward:(id)sender {
    // 1 - Get number of rows in array
    int array_tot = [self.myQuotes count];
    // 2 - Get random index
    if (self.index == 0) {
        self.index = array_tot;
    }
    self.index++;
    
    int ind = (self.index % array_tot);
    // 3 - Get the quote string for the index
    NSString *my_quote = self.myQuotes[ind];
    // 4 - Display the quote in the text view
    self.quoteText.text = [NSString stringWithFormat:@"Quote:\n\n%@",  my_quote];
    [self.fliteController say:my_quote withVoice:self.slt];

}

- (void) pocketsphinxDidReceiveHypothesis:(NSString *)hypothesis recognitionScore:(NSString *)recognitionScore utteranceID:(NSString *)utteranceID {
	NSLog(@"The received hypothesis is %@ with a score of %@ and an ID of %@", hypothesis, recognitionScore, utteranceID);
    if ([hypothesis isEqualToString:@"NEXT"]) {
        [self goForward:nil];
    } else if ([hypothesis isEqualToString:@"PREVIOUS"]) {
        [self goBack:nil];
    }else if ([hypothesis isEqualToString:@"SHOW PHOTO"]) {
        [self SwipeUp:nil];
    }/*else if ([hypothesis isEqualToString:@"SHOW TEXT"]) {
        [self ViewBack:nil];
    }*/

}

- (void) pocketsphinxDidStartCalibration {
	NSLog(@"Pocketsphinx calibration has started.");
}

- (void) pocketsphinxDidCompleteCalibration {
	NSLog(@"Pocketsphinx calibration is complete.");
}

- (void) pocketsphinxDidStartListening {
	NSLog(@"Pocketsphinx is now listening.");
}

- (void) pocketsphinxDidDetectSpeech {
	NSLog(@"Pocketsphinx has detected speech.");
}

- (void) pocketsphinxDidDetectFinishedSpeech {
	NSLog(@"Pocketsphinx has detected a period of silence, concluding an utterance.");
}

- (void) pocketsphinxDidStopListening {
	NSLog(@"Pocketsphinx has stopped listening.");
}

- (void) pocketsphinxDidSuspendRecognition {
	NSLog(@"Pocketsphinx has suspended recognition.");
}

- (void) pocketsphinxDidResumeRecognition {
	NSLog(@"Pocketsphinx has resumed recognition.");
}

- (void) pocketsphinxDidChangeLanguageModelToFile:(NSString *)newLanguageModelPathAsString andDictionary:(NSString *)newDictionaryPathAsString {
	NSLog(@"Pocketsphinx is now using the following language model: \n%@ and the following dictionary: %@",newLanguageModelPathAsString,newDictionaryPathAsString);
}

- (void) pocketSphinxContinuousSetupDidFail { // This can let you know that something went wrong with the recognition loop startup. Turn on OPENEARSLOGGING to learn why.
	NSLog(@"Setting up the continuous recognition loop has failed for some reason, please turn on OpenEarsLogging to learn more.");
}
- (void) testRecognitionCompleted {
	NSLog(@"A test file that was submitted for recognition is now complete.");
}

/*

- (void)pushChildViewController:(UIViewController *)newChildController
{
    // remove any other children that we've popped off, but are still lingering about
    
    for (NSInteger index = [self.childViewControllers count] - 1; index > self.currentChildIndex; index--)
    {
        UIViewController *childController = self.childViewControllers[index];
        [childController willMoveToParentViewController:nil];
        [childController.view removeFromSuperview];
        [childController removeFromParentViewController];
    }
    
    // get reference to the current child controller
    
    UIViewController *currentChildController = self.childViewControllers[self.currentChildIndex];
    
    // set new child to be off to the right
    
    CGRect frame = self.containerView.bounds;
    frame.origin.x += frame.size.width;
    newChildController.view.frame = frame;
    
    // add the new child
    
    [self addChildViewController:newChildController];
    [self.containerView addSubview:newChildController.view];
    [newChildController didMoveToParentViewController:self];
    
    [UIView animateWithDuration:0.5
                     animations:^{
                         CGRect frame = self.containerView.bounds;
                         newChildController.view.frame = frame;
                         frame.origin.x -= frame.size.width;
                         currentChildController.view.frame = frame;
                     }];
    
    self.currentChildIndex++;
}

- (void)popChildViewController
{
    if (self.currentChildIndex == 0)
        return;
    
    UIViewController *currentChildController = self.childViewControllers[self.currentChildIndex];
    self.currentChildIndex--;
    UIViewController *previousChildController = self.childViewControllers[self.currentChildIndex];
    
    CGRect onScreenFrame = self.containerView.bounds;
    
    CGRect offToTheRightFrame = self.containerView.bounds;
    offToTheRightFrame.origin.x += offToTheRightFrame.size.width;
    
    [UIView animateWithDuration:0.5
                     animations:^{
                         currentChildController.view.frame = offToTheRightFrame;
                         previousChildController.view.frame = onScreenFrame;
                     }];
}


- (void)addShadow:(UIView *)view
{
    view.layer.shadowColor = [[UIColor blackColor] CGColor];
    view.layer.shadowOpacity = 0.5;
    view.layer.shadowRadius = 10.0;
    [view.layer setShouldRasterize:YES];
    [view.superview bringSubviewToFront:view];
}

- (void)removeShadow:(UIView *)view
{
    view.layer.shadowRadius = 0.0;
    view.layer.shadowOpacity = 0.0;
    view.layer.shadowColor = [[UIColor clearColor] CGColor];
    [view.layer setShouldRasterize:NO];
}
*/

@end
