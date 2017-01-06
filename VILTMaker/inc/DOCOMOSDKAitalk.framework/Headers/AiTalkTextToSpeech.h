//
//  AiTalkTextToSpeech.h
//  docomo-aitalk-ios-sdk
//  (c) 2014 NTT DOCOMO, INC. All Rights Reserved.
//
#import <Foundation/Foundation.h>
#import <DOCOMOSDKCommon/DOCOMOSDKCommon.h>

#import "AiTalkError.h"

/**
 ＡＩ音声合成 SDK： ＡＩ音声合成問い合わせ処理クラス。

 ＡＩ音声合成用のテキストを音声変換するクラスです。
 
 // のぞみさんの音声で、”こんにちは”を、ＳＳＭＬクラスに登録する
 
 AiTalkVoice * voice = [[AiTalkVoice alloc]initWithVoiceName:@"nozomi"];
 
 [voice addText:@"こんにちは"];
 
 [ssml addVoice:voice];
 
 // ＳＳＭＬ文字列を、ＰＣＭ音声へ変換する。
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
 
 */
@interface AiTalkTextToSpeech : NSObject

@property NSTimeInterval timeoutInterval;

/**
 初期化
 
 @return id
 */
-(id)init;

/**
 １６ビットのエンディアン変換処理を行う。
 
 引数のバイト配列の１６ビットのエンディアン変換を行います。

 AiTalkのＰＣＭ１６ビット音声は、ビッグエンディアンです。
 Androidでは、そのまま再生できないため、本機能を使って、
 エンディアンの変換を行います。

 @param data 音声ＰＣＭリニアのデータ
 @return 変換後データ
 */
+(NSData *)convertByteOrder16:(NSData *)data;

/**
 ＡＩ音声合成のＳＳＭＬ文字列からＰＣＭ音声への変換を行う。

 ＳＳＭＬ文字列から、ＰＣＭ音声に変換を行います。
 独自でＳＳＭＬ文字列を作成したときに利用します。

 
 @param ssml ＳＳＭＬ型の音声変換テキスト情報
 @param onComplete 応答受信完了時処理ハンドラ。
 レスポンス受信が完了した時に呼び出される認識結果処理メソッドを指定します。
 @param onError 応答受信エラー時処理ハンドラ。
 レスポンス受信エラーが発生した時に呼び出されるエラー処理メソッドを指定します。
 @return 音声合成SDKエラー情報(パラメータエラーの場合AiTalkErrorParamを、リクエストを送信した場合はnilを返す)
 @see AiTalkError
 */
-(AiTalkError *)requestAiTalkSsmlToSound:(NSString *)ssml
                             onComplete:(void (^)(NSData *))onComplete
                                onError:(void (^)(SdkError *))onError;

/**
 ＡＩ音声合成のＳＳＭＬ文字列からＡＩカナへの変換を行う。

 ＳＳＭＬ文字列から、ＡＩカナ文字列に変換を行います。


 @param ssml 音声変換テキスト情報
 @param onComplete 応答受信完了時処理ハンドラ。
 レスポンス受信が完了した時に呼び出される認識結果処理メソッドを指定します。
 @param onError 応答受信エラー時処理ハンドラ。
 レスポンス受信エラーが発生した時に呼び出されるエラー処理メソッドを指定します。
 @return 音声合成SDKエラー情報(パラメータエラーの場合AiTalkErrorParamを、リクエストを送信した場合はnilを返す)
 @see AiTalkError
 */
-(AiTalkError *)requestAiTalkSsmlToAikana:(NSString *)ssml
                             onComplete:(void (^)(NSData *))onComplete
                                onError:(void (^)(SdkError *))onError;

/**
 ＡＩ音声合成のＳＳＭＬ文字列からＪＥＩＴＡカナへの変換を行う。

 ＳＳＭＬ文字列から、ＪＥＩＴＡカナ文字列に変換を行います。
 
 @param ssml 音声変換テキスト情報
 @param onComplete 応答受信完了時処理ハンドラ。
 レスポンス受信が完了した時に呼び出される認識結果処理メソッドを指定します。
 @param onError 応答受信エラー時処理ハンドラ。
 レスポンス受信エラーが発生した時に呼び出されるエラー処理メソッドを指定します。
 @return 音声合成SDKエラー情報(パラメータエラーの場合AiTalkErrorParamを、リクエストを送信した場合はnilを返す)
 @see AiTalkError
 */
-(AiTalkError *)requestAiTalkSsmlToJeitakana:(NSString *)ssml
                             onComplete:(void (^)(NSData *))onComplete
                                onError:(void (^)(SdkError *))onError;

/**
 ＡＩ音声合成のＡＩカナ文字列からＰＣＭ音声への変換を行う。

 ＡＩカナ文字列から、ＰＣＭ音声に変換を行います。

 
 @param aikana 音声変換テキスト情報
 @param onComplete 応答受信完了時処理ハンドラ。
 レスポンス受信が完了した時に呼び出される認識結果処理メソッドを指定します。
 @param onError 応答受信エラー時処理ハンドラ。
 レスポンス受信エラーが発生した時に呼び出されるエラー処理メソッドを指定します。
 @return 音声合成SDKエラー情報(パラメータエラーの場合AiTalkErrorParamを、リクエストを送信した場合はnilを返す)
 @see AiTalkError
 */
-(AiTalkError *)requestAikanaToSound:(NSString *)aikana
                             onComplete:(void (^)(NSData *))onComplete
                                onError:(void (^)(SdkError *))onError;

/**
 ＡＩ音声合成のＡＩカナ文字列からＪＥＩＴＡカナへの変換を行う。

 ＡＩカナ文字列から、ＪＥＩＴＡカナ文字列に変換を行います。

 @param aikana 音声変換テキスト情報
 @param onComplete 応答受信完了時処理ハンドラ。
 レスポンス受信が完了した時に呼び出される認識結果処理メソッドを指定します。
 @param onError 応答受信エラー時処理ハンドラ。
 レスポンス受信エラーが発生した時に呼び出されるエラー処理メソッドを指定します。
 @return 音声合成SDKエラー情報(パラメータエラーの場合AiTalkErrorParamを、リクエストを送信した場合はnilを返す)
 @see AiTalkError
 */
-(AiTalkError *)requestAikanaToJeitakana:(NSString *)aikana
                             onComplete:(void (^)(NSData *))onComplete
                                onError:(void (^)(SdkError *))onError;

/**
 ＡＩ音声合成のＪＥＩＴＡカナ文字列からＰＣＭ音声への変換を行う。

 ＪＥＩＴＡカナから、ＰＣＭ音声に変換を行います。

 @param jeitakana　音声変換テキスト情報 SJISバイト配列
 @param onComplete 応答受信完了時処理ハンドラ。
 レスポンス受信が完了した時に呼び出される認識結果処理メソッドを指定します。
 @param onError 応答受信エラー時処理ハンドラ。
 レスポンス受信エラーが発生した時に呼び出されるエラー処理メソッドを指定します。
 @return 音声合成SDKエラー情報(パラメータエラーの場合AiTalkErrorParamを、リクエストを送信した場合はnilを返す)
 @see AiTalkError
 */
-(AiTalkError *)requestJeitakanaToSound:(NSString *)jeitakana
                             onComplete:(void (^)(NSData *))onComplete
                                onError:(void (^)(SdkError *))onError;

@end
