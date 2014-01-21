//
//  CardGameViewController.m
//  Matchismo
//
//  Created by James Reid on 12/30/13.
//  Copyright (c) 2013 Koinonia. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardDeck.h"
#import "PlayingCard.h"
#import "CardMatchingGame.h"

@interface CardGameViewController ()
@property (strong,nonatomic) CardMatchingGame *game;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *gameMode;
@property (weak, nonatomic) IBOutlet UILabel *matchResultsLabel;
@property (weak, nonatomic) IBOutlet UISlider *matchResultsSlider;
@property (nonatomic) NSInteger numberOfCardsToPlayWith;
@end

@implementation CardGameViewController

- (IBAction)changeMatchHistory:(id)sender {
    
    // Round the number
    NSUInteger index = (NSUInteger)(self.matchResultsSlider.value + 0.5);
    
    
    if (index >= [self.game.matchHistory count]) {
 
        if([self.game.matchHistory count] == 0)
        {
            [self.matchResultsSlider setValue:0 animated:YES];
            index = 0;
        } else {
            index = [self.game.matchHistory count] - 1;
            [self.matchResultsSlider setValue:index animated:YES];
        }
    }

    if (index > 0)
    {
        // set match history label to slider value
        NSString *matchHistory = [self.game.matchHistory objectAtIndex:index];
        self.matchResultsLabel.text = matchHistory;

    }
}


- (CardMatchingGame *) game
{
    
     if(!_game) _game = [[CardMatchingGame alloc] initWithCardCountAndMode:[self.cardButtons count]
                                                                usingDeck:[self createDeck]
                                                                 gameMode:self.numberOfCardsToPlayWith];
    
    return _game;
}

- (Deck *)createDeck
{
    return [[PlayingCardDeck alloc] init];
}

- (NSInteger)numberOfCardsToPlayWith
{
    if (!_numberOfCardsToPlayWith) _numberOfCardsToPlayWith = 2;
    return _numberOfCardsToPlayWith;
}

- (IBAction)touchCardButton:(UIButton *)sender
{
    int chosenButtonIndex = [self.cardButtons indexOfObject:sender];
    [self.game chooseCardAtIndex:chosenButtonIndex];
    
    // disable game mode selection
    if (self.gameMode.enabled)
        self.gameMode.enabled = NO;
    
    [self.matchResultsSlider setValue:[self.game.matchHistory count] animated:YES];
    
    // controller must still do its job of interpreting
    // the Model into the view
    [self updateUI];
}


- (IBAction)chooseMatchMode:(UISegmentedControl *)sender {
    
    if (sender.selectedSegmentIndex == 1) {
        // 3-card match mode
        self.numberOfCardsToPlayWith = 3;
    } else {
        // 2-card match mode
        self.numberOfCardsToPlayWith = 2;
    }

}

- (IBAction)redealCardsAlert
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Re-deal Cards?"
                                                    message:@"This will reset your current score."
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"OK", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self dealCards];
    }
}

- (void)dealCards {
    
     // reset game (includes reseting score to zero
    _game = [[CardMatchingGame alloc] initWithCardCountAndMode:[self.cardButtons count]
                                                     usingDeck:[self createDeck]
                                                      gameMode:self.numberOfCardsToPlayWith];
    
    // re-dealing cards to start new game
    // enable game mode selection
    self.gameMode.enabled = YES;
    
    // reset match slider history
    [self.matchResultsSlider setValue:0 animated:YES];
    
    // update UI
    [self updateUI];
    
}


- (void)updateUI
{
    for (UIButton *cardButton in self.cardButtons) {
        int cardButtonIndex = [self.cardButtons indexOfObject:cardButton];
        Card *card = [self.game cardAtIndex:cardButtonIndex];
        [cardButton setTitle:[self titleForCard:card] forState:UIControlStateNormal];
        [cardButton setBackgroundImage:[self backgroundImageForCard:card] forState:(UIControlStateNormal)];
        cardButton.enabled = !card.isMatched;
     }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d",self.game.score];
    
    self.matchResultsLabel.text = [self.game.matchHistory lastObject];
    
    
}

- (NSString *)titleForCard:(Card *)card
{
    return card.isChosen ? card.contents : @"";
}

- (UIImage *) backgroundImageForCard:(Card *)card
{
    return [UIImage imageNamed:card.isChosen ? @"cardfront" : @"cardback"];
}


@end
