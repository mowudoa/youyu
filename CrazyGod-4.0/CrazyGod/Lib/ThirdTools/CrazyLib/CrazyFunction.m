//
//  easyflyFunction.m
//  easyflyDemo
//
//  Created by dukai on 15/6/2.
//  Copyright (c) 2015年 杜凯. All rights reserved.
//

#import "CrazyFunction.h"
#import<CommonCrypto/CommonDigest.h>
static CrazyFunction *function = nil;

@implementation CrazyFunction
{
    UIView *fieldView;
}

+(NSString *) compareCurrentTime:(NSDate*) compareDate

{
    NSTimeInterval  timeInterval = [compareDate timeIntervalSinceNow];
    timeInterval = -timeInterval;
    long temp = 0;
    NSString *result;
    if (timeInterval < 60) {
        result = [NSString stringWithFormat:@"刚刚"];
    }
    else if((temp = timeInterval/60) <60){
        result = [NSString stringWithFormat:@"%ld分前",temp];
    }
    
    else if((temp = temp/60) <24){
        result = [NSString stringWithFormat:@"%ld小时前",temp];
    }
    
    else if((temp = temp/24) <30){
        result = [NSString stringWithFormat:@"%ld天前",temp];
    }
    
    else if((temp = temp/30) <12){
        result = [NSString stringWithFormat:@"%ld月前",temp];
    }
    else{
        temp = temp/12;
        result = [NSString stringWithFormat:@"%ld年前",temp];
    }
    
    return  result;
}

+(void)textfeildSpace:(UITextField *)textFeild space:(float )space
{
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, space, 30)];
    textFeild.leftView = imageView;
    textFeild.leftViewMode = UITextFieldViewModeAlways;
}

+(NSString *)crazy_md5:(NSString *)string{
    
    const char *cStr = [string UTF8String];
    
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5( cStr, strlen(cStr), digest );
    
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH *2];
    
    for(int i =0; i < CC_MD5_DIGEST_LENGTH; i++)
        
        [result appendFormat:@"%02x", digest[i]];
    
    return result;
}
+(NSString *)crazy_MD5:(NSString *)string{
    
    return [CrazyFunction crazy_md5:string].uppercaseString;
}

+(NSString *)crazy_timeToTimestamp:(NSDate *)data{
    //时间转时间戳
    if (data ==nil) {
         data = [NSDate date];//现在时间
    }
   
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[data timeIntervalSince1970]];
    
    return timeSp;
}
+(NSString *)crazy_timestampToTime:(NSString *)timestamp{
    //时间戳转时间
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyyMMddHHMMss"];
    NSDate *date = [formatter dateFromString:timestamp];
    NSString *time = [formatter stringFromDate:date];
    return time;
}
+(int)crazy_RandomNumber:(int)from to:(int)to
{
    return (int)(from + (arc4random() % (to - from + 1) ));
    
}
+(float)returnTextWidth:(float)fontSize title:(NSString *)title{
    NSDictionary *attribute1 = @{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]};
    
    CGSize size1 = [title boundingRectWithSize:CGSizeMake(MAXFLOAT, 0) options:NSStringDrawingTruncatesLastVisibleLine attributes:attribute1 context:nil].size;
    return size1.width;
}
+(float)returnFontSize:(float)fontSize title:(NSString *)title ViewWidth:(float)width{
   
    UIFont *font = [UIFont fontWithName:@"Arial" size:HEIGHT(fontSize)];
    CGSize size = CGSizeMake(width,2000);
    CGSize labelsize = [ title sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    
    CGSize recontentSize = [ title sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];

    return recontentSize.height;
}

//字典或者数组 转换成json串
+(NSString *)crazy_ObjectToJsonString:(id)object{
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:nil
                                                         error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData
                                                 encoding:NSUTF8StringEncoding];
    return jsonString;

}
//json串 转换成字典或者数组
+(id)crazy_JsonStringToObject:(NSString *)JsonString{
    NSData *jsonData = [JsonString dataUsingEncoding:NSUTF8StringEncoding];
    id objc = [NSJSONSerialization JSONObjectWithData:jsonData
                                              options:NSJSONReadingMutableContainers
                                                error:nil];
    return objc;
}
+(NSString *)crazy_pinyin:(NSString *)hanzi{
    NSMutableString *ms;
    if ([hanzi length]) {
        ms = [[NSMutableString alloc] initWithString:hanzi];
        if (CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformMandarinLatin, NO)) {
            
        }
        if (CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformStripDiacritics, NO)) {
        }
    }
    return ms;
}
//手机号码
+(BOOL)CrazyValidatePhoneNum:(NSString *)str
{
    NSString *regex = @"1[0-9]{10}";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    BOOL isMatch = [pred evaluateWithObject:str];
    return isMatch;
}
#pragma 正则匹配银行卡号
+ (BOOL)checkUserBankNumber:(NSString *)BankNumber{
    NSString *regex2 =@"^\\d{16,19}$|^\\d{6}[- ]\\d{10,13}$|^\\d{4}[- ]\\d{4}[- ]\\d{4}[- ]\\d{4,7}$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:BankNumber];
    
}
//身份证号
+(BOOL)CrazyValidateIdentityCard:(NSString *)str
{
    NSString * identityCard  = str;
    //判断位数
    if ([identityCard length] != 15 && [identityCard length] != 18) {
        return NO;
    }
    NSString *carid = identityCard;
    long lSumQT =0;
    //加权因子
    int R[] ={7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2 };
    //校验码
    unsigned char sChecker[11]={'1','0','X', '9', '8', '7', '6', '5', '4', '3', '2'};
    //将15位身份证号转换成18位
    NSMutableString *mString = [NSMutableString stringWithString:identityCard];
    if ([identityCard length] == 15) {
        [mString insertString:@"19" atIndex:6];
        long p = 0;
        const char *pid = [mString UTF8String];
        for (int i=0; i<=16; i++)
        {
            p += (pid[i]-48) * R[i];
        }
        int o = p%11;
        NSString *string_content = [NSString stringWithFormat:@"%c",sChecker[o]];
        [mString insertString:string_content atIndex:[mString length]];
        carid = mString;
        
    }
    
    const char *PaperId  = [carid UTF8String];
    
    //检验长度
    if( 18 != strlen(PaperId)) return -1;
    //校验数字
    for (int i=0; i<18; i++)
    {
        if ( !isdigit(PaperId[i]) && !(('X' == PaperId[i] || 'x' == PaperId[i]) && 17 == i) )
        {
            return NO;
        }
    }
    //验证最末的校验码
    for (int i=0; i<=16; i++)
    {
        lSumQT += (PaperId[i]-48) * R[i];
    }
    if (sChecker[lSumQT%11] != PaperId[17] )
    {
        return NO;
    }
    
    return YES;
}

@end

static CrazyCountdownTimer *onceTimer = nil;

@implementation CrazyCountdownTimer
{
    NSTimer *timer;
}
+(void)crazy_CountdownTimer:(int)Second block:(FinishTimerBolck)block{
    onceTimer = [[CrazyCountdownTimer alloc]init];
    [onceTimer createTimer];
    onceTimer.TimerBolck = block;
}
-(void)createTimer{
    
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(startTimer) userInfo:nil repeats:YES];
}
-(void)startTimer{
    _nowTime --;
    if (self.TimerBolck) {
        self.TimerBolck(_nowTime);
    }
    if (_nowTime ==0) {
        [timer invalidate];
    }
    
}


@end
