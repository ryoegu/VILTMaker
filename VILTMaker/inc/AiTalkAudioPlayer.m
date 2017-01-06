//
//  AiTalkAudioPlayer.m
//  aiTalkSample
//  (c) 2014 NTT DOCOMO, INC. All Rights Reserved.
//

#import "AiTalkAudioPlayer.h"


@implementation AiTalkAudioPlayer

static AiTalkAudioPlayer *sharedData_ = nil;

+ (AiTalkAudioPlayer *)manager{
    @synchronized(self){
        if (!sharedData_) {
            sharedData_ = [[AiTalkAudioPlayer alloc]init];
        }
    }
    return sharedData_;
}

- (id)init
{
    self = [super init];
    if (self) {
        soundArray = [[NSMutableArray alloc] init];
        _soundVolume = 1.0;
    }
    return self;
}

- (void)playSound:(NSData *)data
{
    NSError * error;
    AVAudioPlayer* player = [[AVAudioPlayer alloc] initWithData:data error:&error];
    if (error){
        NSLog(@"error %d %@",(int)error.code, error.localizedDescription);
    }
    [player setNumberOfLoops:0];
    player.volume = _soundVolume;
    player.delegate = (id)self;
    [soundArray insertObject:player atIndex:0];
    [player prepareToPlay];
    [player play];
}

/**
 Responding to Sound Playback Completion
 @param player The audio player that finished playing.
 @param flag YES on successful completion of playback; NO if playback stopped because the system could not decode the audio data.

 @successfully
 */
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    NSLog(@"audioPlayerDidFinishPlaying");
    [soundArray removeObject:player];
}

/**
 Responding to an Audio Decoding Error
 @param player The audio player that encountered the decoding error.
 @param error The decoding error.
 */
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error
{
    NSLog(@"audioPlayerDecodeErrorDidOccur %d %@",(int)error.code,error.localizedDescription);
}



@end
