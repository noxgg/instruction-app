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

//Lazy loaders for Open Ears objects
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
    
    [self.currentInstruction addObserver:self forKeyPath:@"contentSize" options:(NSKeyValueObservingOptionNew) context:NULL];
    [super viewDidLoad];
    self.instructionIndex = 0;
    self.isVoiceEnabled = false;
	// Do any additional setup after loading the view, typically from a nib.

    
    self.instructionCount = [self.instructions count];
    NSArray *words = [NSArray arrayWithObjects:@"PREVIOUS", @"NEXT", @"REPEAT", @"SHOW PHOTO", @"SHOW TEXT", @"REED INSTRUCTION", @"STOP", @"MENU", nil];
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
    
    self.currentImage.hidden = true;
    self.currentInstruction.hidden = false;
    [self switchInstruction];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    UITextView *tv = object;
    CGFloat topCorrect = ([tv bounds].size.height - [tv contentSize].height * [tv zoomScale])/2.0;
    topCorrect = ( topCorrect < 0.0 ? 0.0 : topCorrect );
    tv.contentOffset = (CGPoint){.x = 0, .y = -topCorrect};
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Methods for handling commands issued by the user.
-(IBAction)goBack:(id)sender {
    self.instructionIndex--;
    if (self.instructionIndex < 0) {
        [self returnToMenu];
    } else {
        [self switchInstruction];
    }
}

-(void)returnToMenu {
    [self.currentInstruction removeObserver:self forKeyPath:@"contentSize"];
    [self.pocketsphinxController stopListening];
    [self.pocketsphinxController stopVoiceRecognitionThread];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)goForward:(id)sender {
    ++self.instructionIndex;
    if (self.instructionIndex >= self.instructionCount) {
        [self returnToMenu];
    }
    [self switchInstruction];

}

- (void)switchInstruction {
    if (self.instructionIndex < 0) {
        self.instructionIndex += self.instructionCount;
    } else if (self.instructionIndex >= self.instructionCount) {
        self.instructionIndex = self.instructionIndex % self.instructionCount;
    }
    UIImage *img = [UIImage imageNamed:[self.images objectAtIndex:self.instructionIndex]];
    [self.currentImage setImage:img];
    self.currentImage.contentMode = UIViewContentModeScaleAspectFit;
    self.currentInstruction.text = [NSString stringWithFormat:@"%@%d%@%ld%@%@", @"Step ", self.instructionIndex + 1, @" of ", (long)self.instructionCount, @") ", self.instructions[self.instructionIndex]];
    if (self.isVoiceEnabled) {
        self.fliteController = nil;
        self.fliteController.userCanInterruptSpeech = true;
        [self.fliteController say:self.instructions[self.instructionIndex] withVoice:self.slt];
    }
    
}

-(IBAction)swipeUp:(id) sender{
    NSLog(@"swipe up detected");
    self.currentInstruction.hidden = true;
    self.currentImage.hidden = false;
}

-(IBAction)swipeDown:(id) sender{
    NSLog(@"swipe down updetected");
    self.currentInstruction.hidden = false;
    self.currentImage.hidden = true;
}

-(IBAction)restart:(id)sender {
    [self switchInstruction];
}


//Methods for processing voice input.
- (void) pocketsphinxDidReceiveHypothesis:(NSString *)hypothesis recognitionScore:(NSString *)recognitionScore utteranceID:(NSString *)utteranceID {
	NSLog(@"The received hypothesis is %@ with a score of %@ and an ID of %@", hypothesis, recognitionScore, utteranceID);
    if ([recognitionScore floatValue] < -5000) {
        NSLog(@"Score is too low. Ignoring command");
    } else if ([hypothesis isEqualToString:@"NEXT"]) {
        [self goForward:nil];
    } else if ([hypothesis isEqualToString:@"PREVIOUS"]) {
        [self goBack:nil];
    } else if ([hypothesis isEqualToString:@"REPEAT"]) {
        [self restart:nil];
    } else if ([hypothesis isEqualToString:@"SHOW PHOTO"]) {
        [self swipeUp:nil];
    } else if ([hypothesis isEqualToString:@"SHOW TEXT"]) {
      [self swipeDown:nil];
    } else if ([hypothesis isEqualToString:@"REED INSTRUCTION"]) {
        self.isVoiceEnabled = true;
        [self switchInstruction];
    } else if ([hypothesis isEqualToString:@"STOP"]) {
        self.isVoiceEnabled = false;
    } else if ([hypothesis isEqualToString:@"MENU"]) {
        [self returnToMenu];
    }
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

@end
