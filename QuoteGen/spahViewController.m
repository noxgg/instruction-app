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
    self.instructionIndex = 0;
	// Do any additional setup after loading the view, typically from a nib.
    self.instructions = @[
                      @"1hi",
                      @"2Don't cry over spilt milk",
                      @"3Always look on the bright side of life",
                      @"4Nobody's perfect",
                      @"5Can't see the woods for the trees",
                      @"6Better to have loved and lost then not loved at all",
                      @"7The early bird catches the worm",
                      @"8As slow as a wet week"
                      ];
    self.images= [[NSArray alloc] initWithObjects:
                      @"67.png",
                      @"68.png",
                      @"69.png",
                      @"70.png",
                      @"71.png",
                      @"72.png",
                      @"73.png",
                      @"74.png",
                      nil];
    
    self.instructionCount = [self.instructions count];
    NSArray *words = [NSArray arrayWithObjects:@"PREVIOUS", @"NEXT", @"REPEAT", @"SHOW PHOTO", @"SHOW TEXT", nil];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Methods for handling commands issued by the user.
-(IBAction)goBack:(id)sender {
    self.instructionIndex--;
    [self switchInstruction];
}

-(IBAction)goForward:(id)sender {
    ++self.instructionIndex;
    [self switchInstruction];

}

- (void)switchInstruction {
    if (self.instructionIndex < 0) {
        self.instructionIndex += self.instructionCount;
    } else if (self.instructionIndex >= self.instructionCount) {
        self.instructionIndex = self.instructionIndex % self.instructionCount;
    }
    [self.currentImage setImage:[UIImage imageNamed:[self.images objectAtIndex:self.instructionIndex]]];
    self.currentInstruction.text = self.instructions[self.instructionIndex];
    [self.fliteController say:self.currentInstruction.text withVoice:self.slt];
    
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
    if ([recognitionScore floatValue] < 5000) {
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
