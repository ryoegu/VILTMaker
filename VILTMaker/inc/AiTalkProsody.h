//
//  AiTalkProsody.h
//  docomo-aitalk-ios-sdk
//  (c) 2014 NTT DOCOMO, INC. All Rights Reserved.
//

#import "AiTalkVoiceBase.h"

/**
 ＡＩ音声合成 SDK： ＳＳＭＬ韻律変更タグクラス
 
 テキストをＰＣＭリニア音声変換する際の、読み上げの早さなどを指定できるタグです。
 AiTalkVoice同様に、読み上げたい文字列を追加後、
 AiTalkVoiceに、AiTalkProsodyを追加してください。
 */
@interface AiTalkProsody : AiTalkVoiceBase

/**
 初期化処理

 ＳＳＭＬの韻律変更タグを開始する。

 テキストをＰＣＭリニア音声変換する際の、読み上げの早さなどを指定します。

 @param pitch	   テキストを読み上げるベースラインピッチ
　　　　　　　　基準値は1.0 で、0.50から2.00 の範囲で指定できます。
 @param range	   テキストを読み上げるピッチレンジ
　　　　　　　　基準値は1.0 で、0.00から2.00の範囲で指定できます。
 @param rate	   テキストを読み上げる速度
　　　　　　　　基準値は1.0 で、0.50から4.00 の範囲で指定できます。
 @param volume  テキストを読み上げる音量
　　　　　　　　基準値は1.0 で、0.00から2.00 の範囲で指定できます。
 @return 正常時はidを復帰する。ただし引数が範囲外の場合はnilを復帰する。
 */
-(id)initWithPitch:(float)pitch range:(float)range rate:(float)rate volume:(float)volume;

/**
 ＳＳＭＬの韻律変更タグ全体を取得する。
 
 本クラス内のＳＳＭＬの韻律変更タグ全体の文字列を取得します。
 @return ＳＳＭＬテキスト
 */
-(NSString *)getString;

@end
