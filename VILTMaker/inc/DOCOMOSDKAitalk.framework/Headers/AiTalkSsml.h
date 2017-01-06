//
//  AiTalkSsml.h
//  docomo-aitalk-ios-sdk
//  (c) 2014 NTT DOCOMO, INC. All Rights Reserved.
//

#import <Foundation/Foundation.h>
#import "AiTalkError.h"
#import "AiTalkVoice.h"


/**
 ＡＩ音声合成 SDK： ＳＳＭＬ作成クラス

 ＡＩ音声合成用のＳＳＭＬを作成するクラスで、ＳＳＭＬのＸＭＬの作成を行います。

 容易にＳＳＭＬを作成することができます。
 */
@interface AiTalkSsml : NSObject
{
}

@property NSMutableArray * voicelist;

/**
 初期化処理
 
 @return id
 */
-(id)init;

/**
 ＳＳＭＬ作成クラスに、VOICEタグを追加する。
 
 @param voice voiceタグ
 */
-(AiTalkError *)addVoice:(AiTalkVoice *)voice;


/**
 ＳＳＭＬのＸＭＬテキストを取得する。


 本クラス内のＳＳＭＬの文字列を取得します。


 @return ＳＳＭＬテキスト
 */
-(NSString *)makeSsml;


@end
