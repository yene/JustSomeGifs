//
//  XXXViewController.h
//  JustSomeGifs
//
//  Created by Yannick Weiss on 13/03/14.
//  Copyright (c) 2014 Yannick Weiss. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XXXViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *gifView;
@property (weak, nonatomic) IBOutlet UIButton *starButton;
@property (weak, nonatomic) IBOutlet UIButton *previousButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

- (IBAction)toggleFav:(id)sender;
- (IBAction)previousGif:(id)sender;
- (IBAction)nextGif:(id)sender;


@end
