//
//  AiTalkAudioPlayer.h
//  aiTalkSample
//  (c) 2014 NTT DOCOMO, INC. All Rights Reserved.
//

#import <Foundation/Foundation.h>
#import "AVFoundation/AVFoundation.h"

@interface AiTalkAudioPlayer : NSObject <AVAudioPlayerDelegate>
{
    NSMutableArray *soundArray;
}

@property(nonatomic) float soundVolume;

/**
 シングルトン　インスタンス取得
 */
+ (AiTalkAudioPlayer *)manager;

/**
 音声再生
 
 @param data 音声データ
 */
- (void)playSound:(NSData *)data;

@end
