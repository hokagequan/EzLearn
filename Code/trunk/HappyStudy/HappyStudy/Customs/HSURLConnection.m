//
//  HSURLConnection.m
//  HappyStudy
//
//  Created by Q on 14/10/28.
//  Copyright (c) 2014年 LittleIsland. All rights reserved.
//

#import "HSURLConnection.h"

@implementation HSURLConnection

- (id)initWithRequest:(NSURLRequest *)request delegate:(id)delegate {
    if (self = [super initWithRequest:request delegate:delegate]) {
        self.receivedData = [[NSMutableData alloc] init];
    }
    
    return self;
}

@end
