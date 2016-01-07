//
//  PKVideoDecoder.h
//  DevelopPlayerDemo
//
//  Created by jiangxincai on 16/1/7.
//  Copyright © 2016年 1yyg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMedia/CoreMedia.h>

@class PKVideoDecoder;

@protocol MovieDecoderDelegate <NSObject>
@required
-(void)movieDecoderDidDecodeFrame:(PKVideoDecoder*)decoder pixelBuffer:(CVImageBufferRef)buffer;
@optional
-(void)movieDecoderDidFinishDecoding:(PKVideoDecoder*)decoder;
@end

@interface PKVideoDecoder : NSObject

@property (nonatomic,readonly) BOOL   isRunning, isFinished;
@property (nonatomic,assign)   int    format;
@property (nonatomic,assign)   int    frameRate;
@property (nonatomic,assign)   double currentTime;
@property (nonatomic,assign)   BOOL   loop;
@property (nonatomic,assign)   id<MovieDecoderDelegate> delegate;

-(id)initWithMovie:(NSURL*)path format:(int)format;
-(BOOL)loadMovie:(NSURL*)path;
-(void)start;
-(void)pause;
-(void)stop;
-(void)captureNext;

@end
