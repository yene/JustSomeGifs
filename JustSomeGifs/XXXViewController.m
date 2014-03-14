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
  NSArray *gifs;
  NSUInteger position;
}
@end

@implementation XXXViewController

- (NSString *)documentsDirectory {
  return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

- (void)setup;
{
  NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[self documentsDirectory] error:nil];
  
  if ([files count] != 0) return;
  
  // folder is empty, do first time setup
  [self copyGifWithName:@"cRozqMJ"];
  [self copyGifWithName:@"tqdCDsG"];
  [self copyGifWithName:@"1eU2UEn"];
  [self copyGifWithName:@"F8oNz3Q"];
  [self copyGifWithName:@"uSaXek5"];
}

- (void)copyGifWithName:(NSString *)name;
{
  NSString *resourcePath = [[NSBundle mainBundle] pathForResource:name ofType:@"gif"];
  NSString *gifFileName = [NSString stringWithFormat:@"%@.gif", name];
  NSString *gifPath = [[self documentsDirectory] stringByAppendingPathComponent:gifFileName];
  [[NSFileManager defaultManager] copyItemAtPath:resourcePath toPath:gifPath error:nil];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self setup];
  position = 0;
  
  [self showGif];
}

- (void)showGif;
{
  gifs = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[self documentsDirectory] error:nil];
  NSString *path = [[self documentsDirectory] stringByAppendingPathComponent:gifs[position]];
  NSURL *url = [NSURL fileURLWithPath:path];
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
  } else {
    [self.starButton setImage:[UIImage imageNamed:@"star2.png"] forState:UIControlStateNormal];
  }
  isFaved = !isFaved;
}

- (IBAction)previousGif:(id)sender {
  position = (position == 0) ? [gifs count]-1 : --position;
  [self showGif];
}

- (IBAction)nextGif:(id)sender {
  position = ++position % [gifs count];
  [self showGif];
}
@end
