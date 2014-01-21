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
@property (nonatomic, readwrite) NSInteger gameMode;
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

- (instancetype)initWithCardCountAndMode:(NSUInteger)count
                        usingDeck:(Deck *)deck
                         gameMode:(NSUInteger)mode {
    
    self = [self initWithCardCount:count usingDeck:deck];
    self.gameMode = mode;
    NSLog(@"Game Mode is: %d",self.gameMode);
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

            
            // match against other cards
            
            // First we store the cards that are chosen and not matched in currentChosenCards
            NSMutableArray *currentChosenCards = [[NSMutableArray alloc] init];
            NSMutableString *statusCurrentChosenCards = [[NSMutableString alloc] init];
                                                          
            for (Card *otherCard in self.cards) {
                if (otherCard.isChosen && !otherCard.isMatched) {
                    [currentChosenCards addObject:otherCard];
                    [statusCurrentChosenCards appendFormat:@"%@ ", otherCard.contents];
                }
            }
 
            
            
            // The model is already tracking how many cards are currently chosen and not matched
            // So all we need to do is match that count with the number of cards we are playing with
            // We do a -1 because currentChosenCards doesn't include the card that was just clicked
            if ([currentChosenCards count] == self.gameMode-1) {
                int matchScore = [card match:currentChosenCards];
                if (matchScore) {
                    self.score += matchScore * MATCH_BONUS;
                    for (Card *otherCard in currentChosenCards) {
                        otherCard.matched = YES;
                    }
                    card.matched = YES;

                    // add match results to match history
                     matchResults=[[NSString stringWithFormat:@"Scored: %d. Match found for: %@ ", matchScore * MATCH_BONUS, card.contents] stringByAppendingString:statusCurrentChosenCards];
                        
                } else {
                        self.score -=MISMATCH_PENALTY;
                        for (Card *otherCard in currentChosenCards) {
                            otherCard.chosen = NO;
                        }

                        // add match results to match history
                        matchResults=[[NSString stringWithFormat:@"Penalty: %d. No match found for: %@ ", MISMATCH_PENALTY, card.contents] stringByAppendingString:statusCurrentChosenCards];
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
