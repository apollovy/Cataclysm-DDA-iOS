//
//  firebase.m
//  CDDA
//
//  Created by Аполлов Юрий Андреевич on 09.12.2022.
//  Copyright © 2022 Аполлов Юрий Андреевич. All rights reserved.
//

@import FirebaseCore;
@import Foundation;

NSString* testGroupKey = @"testGroup";

NSString* getTestGroup() {
    return [NSUserDefaults.standardUserDefaults stringForKey:testGroupKey];
}

void setTestGroup() {
    int r = arc4random_uniform(2) + 1;  // 1|2
    [NSUserDefaults.standardUserDefaults setObject:[NSString stringWithFormat:@"%i", r]
                                         forKey:testGroupKey];
}

void configureFirebase() {
    [FIRApp configure];
    NSString* testGroup = getTestGroup();
    if (testGroup == nil) {
        setTestGroup();
    }
}
