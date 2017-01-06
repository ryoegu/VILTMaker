//
//  AiTalkError.h
//  docomo-aitalk-ios-sdk
//  (c) 2014 NTT DOCOMO, INC. All Rights Reserved.
//

#import <Foundation/Foundation.h>

/**

 */
typedef enum AiTalkErrorType : NSInteger
{
    AiTalkErrorParam      = 100901,  // パラメータ不正
    AiTalkErrorAuth       = 100902,  // 認証失敗
    AiTalkErrorSdkfail    = 100903,  // SDK内処理失敗
    AiTalkErrorTimeout    = 100904,  // タイムアウト
    AiTalkErrorCongestion = 100905,  // 輻輳規制
    AiTalkErrorServer     = 100906   // その他サーバーエラー
    
}AiTalkErrorType;


/**
 ＡＩ音声合成 SDK： エラー情報
 

 文字認識SDKのリクエスト送信の結果によりエラー定数を設定する。
 
 エラー定数
 
 AiTalkErrorParam パラメータ不正
 
 AiTalkErrorAuth  認証失敗
 
 AiTalkErrorSdkfail  SDK内処理失敗
 
 AiTalkErrorTimeout  タイムアウト
 
 AiTalkErrorCongestion  一時利用不可
 
 AiTalkErrorServer  その他サーバーエラー
 
 */
@interface AiTalkError : NSError

@end