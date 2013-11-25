//
//  ParentDelegate.h
//  InstructionApp
//
//  Created by Guest Admin on 11/24/13.
//  Copyright (c) 2013 Scott Palomino. All rights reserved.
//

#import <Foundation/Foundation.h>

// Protocol used for "pushing" and "popping" scenes.
 

@protocol ParentControllerDelegate <NSObject>

/*********************************************
 * @name Methods
 *********************************************/

/** Push child view controller onto stack.
 
 @param newChildController The view controller to which you are pushing.
 */

- (void)pushChildViewController:(UIViewController *)newChildController;

/** Pop child view controller onto stack.
 
 @warning Note, while this visually appears to pop the child off the stack, it actually doesn't pop it off, but rather keeps it on the stack so that we can swipe back to it if we need.
 
 This view controller is retained until a view controller earlier in the stack pushes to a new view controller.
 
 */

- (void)popChildViewController;

/** Iterate through the gestures for the subviews of a scene's main view, making sure that we configure of those gestures to require the edge swipe gesture to fail. This ensures that the edge swipe gesture takes precencence.
 
 @param childView The view for whom we'll iterate through its subviews, making sure that any gesture recognizers they have will
 
 @note Calling this method is generally not needed, but if the scene has a scroll view or web view, this avoids ambiguity as to when the edge swipe gesture will take place.
 
 @warning Note, if this is used in conjunction with text view, entering and exiting edit mode in the `UITextView` may cause its gestures to be removed and added, and thus you might want to call this method again if the `UITextView` changes from view to edit modes and back.
 */


@end
