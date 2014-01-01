//
//  Card.m
//  Matchismo
//
//  Created by James Reid on 12/31/13.
//  Copyright (c) 2013 Koinonia. All rights reserved.
//

#import "Card.h"

@implementation Card

- (int)match:(NSArrary *)otherCards
{
    int score = 0;
    
    for([Card *card in otherCards])
    {
        if([card.contents isEqualToString:self.contents]) {
            score = 1;
        }
    }
    return score;
}

@end
