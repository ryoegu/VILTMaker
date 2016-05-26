//
//  AiTalkVoice.h
//  docomo-aitalk-ios-sdk
//  (c) 2014 NTT DOCOMO, INC. All Rights Reserved.
//

#import "AiTalkVoiceBase.h"
#import "AiTalkError.h"
#import "AiTalkProsody.h"

/**
 ＡＩ音声合成 SDK： voiceタグ情報
 */
@interface AiTalkVoice : AiTalkVoiceBase

/**
 ＳＳＭＬのＶＯＩＣＥタグを開始する。
 
 
 テキストをＰＣＭリニア音声変換する際の、音声を指定します。
 
 音声はリファレンスの音声辞書名を指定してください。
 
 @param voicename	   リファレンスの音声辞書名
 
 @return id
 */
-(id)initWithVoiceName:(NSString *)voicename;

/**
 ＳＳＭＬのＶＯＩＣＥタグを返す。
 @return voiceタグ
 */
-(NSString *)getString;

/**
 SSML作成クラスに、韻律変更タグを追加する
 
 @param prosody 韻律変更タグ
 @see AiTalkError
 @see AiTalkProsody
 */
-(AiTalkError *)addProsody:(AiTalkProsody *)prosody;

@end
