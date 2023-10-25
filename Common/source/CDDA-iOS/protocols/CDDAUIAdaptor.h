//
//  CDDAUIAdaptor.h
//  CBNFramework
//
//  Created by Аполлов Юрий Андреевич on 19.10.2023.
//  Copyright © 2023 Аполлов Юрий Андреевич. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CDDAUIAdaptor <NSObject>

-(void)resizeToFullScreenOnScreenResize;
-(void)doNothingOnScreenResize;

@end

NS_ASSUME_NONNULL_END
