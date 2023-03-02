//
//  main.m
//  playground
//
//  Created by Аполлов Юрий Андреевич on 01.03.2023.
//  Copyright © 2023 Аполлов Юрий Андреевич. All rights reserved.
//

#import <Foundation/Foundation.h>

int main() {
    NSDictionary* myDict = @{@"a": @"a"};
//    NSDictionary* myDict2 = [myDict initWithDictionary:@{@"b": @"b"}];  // Thread 1: EXC_BAD_INSTRUCTION (code=EXC_I386_INVOP, subcode=0x0)

//    NSDictionary* myEmptyDict = @{};
//    NSDictionary* myDict2 = [myEmptyDict initWithDictionary:@{@"b": @"b"}];  // Thread 1: "*** -[NSDictionary initWithObjects:forKeys:count:]: method only defined for abstract class.  Define -[__NSDictionary0 initWithObjects:forKeys:count:]!"

//    NSDictionary* myNullDict;
//    NSDictionary* myDict2 = [myNullDict initWithDictionary:@{@"b": @"b"}];  // myDict: { a = a; }, myDict2: (null)
    
//    NSDictionary* myInitedDict = [[NSDictionary alloc] init];
//    NSDictionary* myDict2 = [myInitedDict initWithDictionary:@{@"b": @"b"}];  // Thread 1: "*** -[NSDictionary initWithObjects:forKeys:count:]: method only defined for abstract class.  Define -[__NSDictionary0 initWithObjects:forKeys:count:]!"
    
    NSMutableDictionary* myDict2 = [[NSMutableDictionary alloc] init];
    [myDict2 addEntriesFromDictionary:@{@"b": @"b"}];
    [myDict2 addEntriesFromDictionary:myDict];
    [myDict2 addEntriesFromDictionary:NULL];

    NSLog(@"myDict: %@, myDict2: %@", myDict, myDict2);
    
    return 0;
}
