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
  NSMutableArray *gifs;
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

- (void)loadFavedGifs;
{
  NSArray *fileNames = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[self documentsDirectory] error:nil];
  
  gifs = [NSMutableArray array];
  
  for (NSString *fileName in fileNames) {
    NSString *path = [[self documentsDirectory] stringByAppendingPathComponent:fileName];
    NSURL *url = [NSURL fileURLWithPath:path];
    [gifs addObject:url];
  }
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
  [self loadFavedGifs];
  position = 0;
  
  [self hideUI];
  [self showGif];

  [self loadGifURLsFromReddit];
}

- (void)showGif;
{
  self.gifView.image = [UIImage animatedImageWithAnimatedGIFData:[NSData dataWithContentsOfURL:gifs[position]]];
  
  [self performSelector:@selector(showNextGif) withObject:nil afterDelay:[self.gifView.image duration] * 2];
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
  [self showUI];
}

- (IBAction)previousGif:(id)sender {
  [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(showNextGif) object:nil];
  position = (position == 0) ? [gifs count]-1 : --position;
  [self showGif];
  [self showUI];
}

- (IBAction)nextGif:(id)sender {
  [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(showNextGif) object:nil];
  position = ++position % [gifs count];
  [self showGif];
  [self showUI];
}

- (void)showNextGif;
{
  position = ++position % [gifs count];
  [self showGif];
}

- (void)showUI;
{
  [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideUI) object:nil];
  [self performSelector:@selector(hideUI) withObject:nil afterDelay:1.5];
    [self.nextButton setAlpha:1];
    [self.previousButton setAlpha:1];
    [self.starButton setAlpha:1];
}

- (void)hideUI;
{
  [UIView animateWithDuration:1.0 animations:^(void) {
    [self.nextButton setAlpha:0];
    [self.previousButton setAlpha:0];
    [self.starButton setAlpha:0];
  }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
  [super touchesBegan:touches withEvent:event];
  [self showUI];
}

- (void)loadGifURLsFromReddit;
{
  NSURL *url = [[NSURL alloc] initWithString:@"http://www.reddit.com/r/gifs.json"];
  
  [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:url] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
    
    if (error) {
      // handle error :D
    } else {
      [self parseJSON:data];
    }
  }];
}

- (void)parseJSON:(NSData *)data;
{
  NSError *localError = nil;
  NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&localError];
  
  if (localError) {
    // handle error :D
  }
  NSArray *results = [parsedObject valueForKeyPath:@"data.children.data.url"];
  for (NSString *url in results) {
    [gifs performSelectorOnMainThread:@selector(addObject:) withObject:[NSURL URLWithString:url] waitUntilDone:YES];
  }
}

@end
