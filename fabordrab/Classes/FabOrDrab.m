//
//  FabOrDrab.m
//  fabordrab
//
//  Created by Mark Sands on 5/29/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "FabOrDrab.h"
#import "TwitterLoginView.h"

@implementation FabOrDrab

@synthesize loginButton;

- (id) init
{
	NSLog(@"Can you hear me now?!");
	
	if ( self = [super init] ) {
		// success!
		loginButton = [[UIBarButtonItem alloc] initWithTitle:@"SignIn" style:UIBarButtonItemStylePlain target:self action:@selector(login:)];
		self.navigationItem.rightBarButtonItem = loginButton;
	}

	return self;
}

- (void) login:(id)sender
{
	TwitterLoginView *next = [[TwitterLoginView alloc] init];
	[self.navigationController pushViewController:next animated:YES];
	[next release];	
}

- (void)dealloc
{
	[super dealloc];
	[loginButton release];
}


@end
