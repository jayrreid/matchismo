//
//  PlayingCardDeck.m
//  Matchismo
//
//  Created by James Reid on 12/31/13.
//  Copyright (c) 2013 Koinonia. All rights reserved.
//

#import "PlayingCardDeck.h"
#import "PlayingCard.h"

@implementation PlayingCardDeck


// Behaves as a constructor for the class
// The return type "instancetype" tells the compiler that this method
// returns an object which will be the same type as the object that the
// message was sent to.
-(instancetype)init
{
    // call super class constructor
    self = [super init];
    
    if (self) {
        // iterate through all the suits and ranks
        for (NSString *suit in [PlayingCard validSuits]) {
            for (NSUInteger rank = 1; rank <= [PlayingCard maxRank]; rank++) {
                PlayingCard *card = [[PlayingCard alloc] init];
                card.rank = rank;
                card.suit = suit;
                
                // add to self which is a playing card deck
                [self addCard: card];
            }
         }
       }
    
    return self;
}

@end
