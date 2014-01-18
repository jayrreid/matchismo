//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by James Reid on 1/4/14.
//  Copyright (c) 2014 Koinonia. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame()
@property (nonatomic, readwrite) NSInteger score;
@property (nonatomic, strong) NSMutableArray *cards; // of Card
@end

static const int MISMATCH_PENALTY = 2;
static const int MATCH_BONUS = 4;
static const int COST_TO_CHANGE = 1;

@implementation CardMatchingGame

- (NSMutableArray *)cards
{
    if(!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

- (NSMutableArray *) matchHistory {
    if(!_matchHistory) _matchHistory= [[NSMutableArray alloc] init];
    return _matchHistory;
}

- (instancetype)initWithCardCount:(NSUInteger)count
                   usingDeck:(Deck *)deck
{
    self = [super init]; //super's (NSObject) designated initializer
    
    if(self) {
        for (int i =0; i < count; i++) {
            Card *card = [deck drawRandomCard];
            if(card) {
                [self.cards addObject:card];
            } else {
                // return nil if we cannot initialize properly
                self = nil;
                break;
            }
        }
        
        // set score to zero
        self.score = 0;
    }
    
    return self;
}

- (Card *)cardAtIndex:(NSUInteger)index
{
    return (index<[self.cards count]) ? self.cards[index] : nil;
}


- (void)chooseCardAtIndex:(NSUInteger)index
{
    Card *card = [self cardAtIndex:index];
    NSString *matchResults;
    
    if (!card.isMatched) {
        
        matchResults=[NSString stringWithFormat:@"%@",card.contents];
        
        if(card.isChosen) {
            card.chosen = NO;
        } else {
            // match against other chosen cards
            for (Card *otherCard in self.cards) {
                if(otherCard.isChosen && !otherCard.isMatched) {
                    int matchScore = [card match:@[otherCard]];
                    if(matchScore) {
                        self.score +=matchScore * MATCH_BONUS;
                        otherCard.matched = YES;
                        card.matched = YES;
                        
                        // add match results to match history
                        matchResults=[NSString stringWithFormat:@"%@ %@ %@ %@ %d %@",otherCard.contents,card.contents,@"Matched",@"for",(matchScore * MATCH_BONUS),@"points"];
                        
                    } else {
                        self.score -=MISMATCH_PENALTY;
                        otherCard.chosen = NO;
                        
                        // add match results to match history
                        matchResults=[NSString stringWithFormat:@"%@ %@ %@ %d %@",otherCard.contents,card.contents,@" Don't Match!",MISMATCH_PENALTY,@" penalty points"];
                    }
                    break; // can only choose 2 cards for now
                }
            }
            self.score -= COST_TO_CHANGE;
            card.chosen = YES;
        }
        // add results to match history
        [self.matchHistory addObject:matchResults];
        
    }
    
    
}


@end
