//
//  UIViewController+Logging.m
//
//  Created by Geoffrey Grosenbach on 8/25/09.
//  Copyright 2009 Topfunky Corporation. MIT Licensed.
//

#import "LoggingViewController.h"


@implementation LoggingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        NSLog(@"%@ initWithNibName:bundle:", [self class]);
    }
    return self;
}

- (void)loadView {
	NSLog(@"%@ loadView", [self class]);
	[super loadView];
}

- (void)viewDidLoad {
  NSLog(@"%@ viewDidLoad", [self class]);
  [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
  NSLog(@"%@ viewWillAppear:", [self class]);
  [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
  NSLog(@"%@ viewDidAppear:", [self class]);
  [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
  NSLog(@"%@ viewWillDisappear:", [self class]);
  [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
  NSLog(@"%@ viewDidDisappear:", [self class]);
  [super viewDidDisappear:animated];
}

- (void)viewDidUnload {
  NSLog(@"%@ viewDidUnload", [self class]);
}

- (void)didReceiveMemoryWarning {
  NSLog(@"%@ didReceiveMemoryWarning", [self class]);
  [super didReceiveMemoryWarning];
}

- (void)dealloc {
  NSLog(@"%@ dealloc", [self class]);
  [super dealloc];
}


@end
