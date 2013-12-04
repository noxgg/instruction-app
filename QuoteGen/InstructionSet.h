//
//  InstructionSet.h
//  InstructionApp
//
//  Created by Scott Palomino on 12/1/13.
//  Copyright (c) 2013 Scott Palomino. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InstructionSet : NSObject
    @property (nonatomic, strong) NSString *title;
    @property (nonatomic, strong) NSArray *instructions;
    @property (nonatomic, strong) NSArray *images;
@end
