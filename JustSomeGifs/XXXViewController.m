//
//  XXXViewController.m
//  JustSomeGifs
//
//  Created by Yannick Weiss on 13/03/14.
//  Copyright (c) 2014 Yannick Weiss. All rights reserved.
//

#import "XXXViewController.h"
#import "UIImage+animatedGIF.h"

@interface XXXViewController () {
  BOOL isFaved;
}
@end

@implementation XXXViewController

- (NSString *)documentsDirectory {
  return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

- (void)viewDidLoad
{
  [super viewDidLoad];

  NSURL *url = [[NSBundle mainBundle] URLForResource:@"cRozqMJ" withExtension:@"gif"];
  self.gifView.image = [UIImage animatedImageWithAnimatedGIFData:[NSData dataWithContentsOfURL:url]];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (IBAction)toggleFav:(id)sender {
  if (isFaved) {
    [self.starButton setImage:[UIImage imageNamed:@"star.png"] forState:UIControlStateNormal];
  }
}

- (IBAction)previousGif:(id)sender {
}

- (IBAction)nextGif:(id)sender {
}
@end
