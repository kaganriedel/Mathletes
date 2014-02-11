//
//  FlashCard.m
//  Mathletes
//
//  Created by Matthew Voracek on 2/11/14.
//  Copyright (c) 2014 Kagan Riedel. All rights reserved.
//

#import "FlashCard.h"

@implementation FlashCard


-(void)cardDifficulty
{
    _difficultyDictionary = [NSDictionary new];
    _difficultyDictionary = @{@0: @1
                              @1: @1
                              @2: @1
                              @3: @1
                              @4: @1
                              @5: @1
                              @6: @1
                              @7: @1
                              @8: @1
                              @9: @1
                              @10: @1
                              @11: @1
                              @12: @1
                              @13: @1
                              @14: @1
                              @15: @1
                              @16: @1
                              @17: @1
                              @18: @1
                              @19: @1
                              @20: @1
                              @21: @1
                              @22: @1
                              @23: @1
                              @24: @1
                              @25: @1
                              @26: @1
                              @27: @2
                              @28: @2
                              @29: @2
                              @30: @1
                              @31: @1
                              @32: @1
                              @33: @1
                              @34: @1
                              @35: @2
                              @36: @2
                              @37: @2
                              @38: @3
                              @39: @3
                              @40: @1
                              @41: @1
                              @42: @1
                              @43: @1
                              @44: @2
                              @45: @2
                              @46: @2
                              @47: @2
                              @48: @3
                              @49: @3
                              @50: @1
                              @51: @1
                              @52: @1
                              @53: @2
                              @54: @2
                              @55: @2
                              @56: @3
                              @57: @3
                              @58: @4
                              @59: @4
                              @60: @1
                              @61: @1
                              @62: @1
                              @63: @2
                              @64: @2
                              @65: @3
                              @66: @3
                              @67: @4
                              @68: @4
                              @69: @4
                              @70: @1
                              @71: @1
                              @72: @2
                              @73: @2
                              @74: @3
                              @75: @3
                              @76: @4
                              @77: @4
                              @78: @4
                              @79: @4
                              @80: @1
                              @81: @1
                              @82: @2
                              @83: @3
                              @84: @3
                              @85: @4
                              @86: @4
                              @87: @4
                              @88: @4
                              @89: @4
                              @90: @1
                              @91: @1
                              @92: @2
                              @93: @3
                              @94: @3
                              @95: @4
                              @96: @4
                              @97: @4
                              @98: @4
                              @99: @4
                              };
}

-(void)newMathProblem
{
    int highestRange = 10;
    int divisionModifier = 0;
    
    [var1Label setText:[NSString stringWithFormat:@"%i", arc4random()%(highestRange-divisionModifier)+divisionModifier]];
    [var2Label setText:[NSString stringWithFormat:@"%i", arc4random()%(highestRange-divisionModifier)+divisionModifier]];
    [NSLog(@"var1: %i var2: %i", var1Label.text.intValue, var2Label.text.intValue);
}
     

@end
