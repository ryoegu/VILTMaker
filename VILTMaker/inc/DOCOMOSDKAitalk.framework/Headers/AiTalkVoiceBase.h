//
//  AiTalkVoiceBase.h
//  docomo-aitalk-ios-sdk
//  (c) 2014 NTT DOCOMO, INC. All Rights Reserved.
//

#import <Foundation/Foundation.h>
#import "AiTalkError.h"

/* 日付フォーマットタイプ定数 */
typedef enum dateFormatType {
    DATE_TYPE_Y = 0,
    DATE_TYPE_M = 1,
    DATE_TYPE_D = 2,
    DATE_TYPE_YM = 3,
    DATE_TYPE_MY = 4,
    DATE_TYPE_MD = 5,
    DATE_TYPE_DM = 6,
    DATE_TYPE_YMD = 7,
    DATE_TYPE_DMY = 8,
    DATE_TYPE_MDY = 9
} dateFormatType;


/* 日付フォーマットタイプ定数 */
typedef enum timeFormatType {
    TIME_TYPE_H = 0,
    TIME_TYPE_M = 1,
    TIME_TYPE_S = 2,
    TIME_TYPE_HM = 3,
    TIME_TYPE_MS = 4,
    TIME_TYPE_HMS = 5,
    TIME_TYPE_H12 = 6,
    TIME_TYPE_HM12 = 7,
    TIME_TYPE_HMS12 = 8
} timeFormatType;

/**
 ＡＩ音声合成 SDK： voiceタグの規定クラス
 
 
 */
@interface AiTalkVoiceBase : NSObject
{
    /** ＳＳＭＬのＸＭＬテキスト情報 */
    NSString * ssml_txt;
}

/**
 初期化処理
 
 @return id
 */
-(id)init;

/**
 ＳＳＭＬにテキストを追加する。
 
 
 テキストをＰＣＭリニア音声変換する際のテキストを指定します。
 
 
 "nozomi"さんの声で、"こんにちは"のＳＳＭＬを作成する例です。
 
 AiTalkSsml * ssml = [[AiTalkSsml alloc]init];
 
 AiTalkVoice * voice = [[AiTalkVoice alloc]initWithVoiceName:@"nozomi"];
 
 [voice addText:@"こんにちは"];
 
 [voice addBreak:1000];
 
 [voice addText:@"音声合成のテストを始めます。"];
 
 [voice addBreak:1000];
 
 [voice addText:@"今日の日付は"];
 
 [voice addDate:DATE_TYPE_YMD date:[NSDate date]];
 
 [voice addText:@"です。"];
 
 [voice addBreak:1000];
 
 [voice addBreak:1000];
 
 [voice addText:@"現在の時刻は"];
 
 [voice addTime:TIME_TYPE_HMS time:[NSDate date]];
 
 [voice addText:@"です。"];
 
 [voice addBreak:1000];
 
 [voice addText:@"電話番号は"];
 
 [voice addTelephone:@"03-1234-5678"];
 
 [voice addText:@"です。"];
 
 [voice addBreak:1000];
 
 [voice addText:@"さようなら"];
 
 [ssml addVoice:voice];
 
 AiTalkTextToSpeech * search = [[AiTalkTextToSpeech alloc]init];
 
 AiTalkError *sendError = [search requestAiTalkSsmlToSound:[ssml makeSsml]
 
 onComplete:^(NSData *data)
 
 {

 //  データ受信後処理

 } onError:^(SdkError *receiveError) {
     
 //  受信エラー時の処理
     
 }];
 
 if(sendError){
 
 //  送信エラー時の処理
  
 }
 
 @param text ＳＳＭＬに追加したい文字列
 @return エラー情報
 @see AiTalkError
 */
-(AiTalkError *)addText:(NSString *)text;

/**
 ＳＳＭＬに無音時間タグを追加する。
 
 
 テキストをＰＣＭリニア音声変換する際の、テキストとテキストの間の無音時間を指定します。
 
 
 テキストとテキストの間に、一秒待つ例です。
 
 [voice addText:@"こんにちは"];
 
 [voice addBreak:1000];
 
 [voice addText:@"さようなら"];

 
 @param msec	   無音時間（ミリ秒）
 　　　　　　　　80msから30,000ms の範囲で指定できます。
 
 @return エラー情報
 @see AiTalkError
 */
-(AiTalkError *)addBreak:(int)msec;
/**
 ＳＳＭＬに日付タグを追加する。
 
 
 日付をＰＣＭリニア音声変換する機能です。
 
 日本語で年月日を読み上げます。
 
 
 日付を読み上げる例です
 
 [voice addDate:DATE_TYPE_YMD date:[NSDate date]];
 
 
 @param date_type      年月日フォーマット（dateFormatTypeを利用）
 
 dateFormatType
 
 　　日付フォーマットタイプ定数
 
 DATE_TYPE_Y 　年。
 
 DATE_TYPE_M 　月。
 
 DATE_TYPE_D 　日。
 
 DATE_TYPE_YM 　年月。
 
 DATE_TYPE_MY 　月年。
 
 DATE_TYPE_MD 　月日。
 
 DATE_TYPE_DM 　日月。
 
 DATE_TYPE_YMD 　年月日。
 
 DATE_TYPE_DMY 　日月年。
 
 DATE_TYPE_MDY 　月日年。
 
 
 @param date        年月日
 
 @return エラー情報
 @see AiTalkError
 */
-(AiTalkError *)addDate:(dateFormatType)date_type date:(NSDate *)date;

/**
 ＳＳＭＬに時間を追加する。
 
 
 時間をＰＣＭリニア音声変換する機能です。
 
 日本語で時分秒を読み上げます。
 
 
 時間を読み上げる例です
 
 [voice addTime:TIME_TYPE_HMS time:[NSDate date]];
 
 
 @param time_type 時間フォーマット（timeFormatTypeを利用）
 
 timeFormatType
 
 　　時刻フォーマットタイプ定数
 
 TIME_TYPE_H 　時。
 
 TIME_TYPE_M 　分。
 
 TIME_TYPE_S 　秒。
 
 TIME_TYPE_HM 　時分。
 
 TIME_TYPE_MS 　分秒。
 
 TIME_TYPE_HMS 　時分秒。
 
 TIME_TYPE_H12 　午前午後つきの時。
 
 TIME_TYPE_HM12 　午前午後つきの時分。
 
 TIME_TYPE_HMS12 　午前午後つきの時分秒。
 

 @param time 時間
 @return エラー情報
 @see AiTalkError
 */
-(AiTalkError *)addTime:(timeFormatType)time_type time:(NSDate *)time;

/**
 ＳＳＭＬに電話番号を追加する。
 
 
 電話番号をＰＣＭリニア音声変換する機能です。
 
 日本語で電話番号を読み上げます。
 
 
 電話番号を読み上げる例です
 
 [voice addTelephone:@"03-1234-5678"];
 
 
 @param telephone   電話番号（リファレンス参照）
 
 @return エラー情報
 @see AiTalkError
 */
-(AiTalkError *)addTelephone:(NSString *)telephone;

-(NSString *)getString;

@end
