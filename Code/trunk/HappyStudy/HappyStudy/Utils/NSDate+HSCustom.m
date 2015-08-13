//
//  NSDate+HSCustom.m
//  HappyStudy
//
//  Created by Q on 14/10/29.
//  Copyright (c) 2014年 LittleIsland. All rights reserved.
//

#import "NSDate+HSCustom.h"

@implementation NSDate (HSCustom)

- (void)year:(NSInteger *)year month:(NSInteger *)month day:(NSInteger *)day hour:(NSInteger *)hour min:(NSInteger *)min second:(NSInteger *)second {
    NSDateComponents *comp = [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond
                                                             fromDate:self];
    
    if (year) {
        *year = comp.year;
    }
    if (month) {
        *month = comp.month;
    }
    if (day) {
        *day = comp.day;
    }
    if (hour) {
        *hour = comp.hour;
    }
    if (min) {
        *min = comp.minute;
    }
    if (second) {
        *second = comp.second;
    }
}

@end
