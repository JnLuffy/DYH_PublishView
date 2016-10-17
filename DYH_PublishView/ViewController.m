//
//  ViewController.m
//  DYH_PublishView
//
//  Created by IOS.Mac on 16/10/12.
//  Copyright © 2016年 com.elepphant.pingchuan. All rights reserved.
//

#import "ViewController.h"
#import "Masonry.h"
#import "YYText.h"


// 屏幕高度
#define SCREEN_HEIGHT             [[UIScreen mainScreen] bounds].size.height
// 屏幕宽度
#define SCREEN_WIDTH              [[UIScreen mainScreen] bounds].size.width


@interface ViewController ()<YYTextViewDelegate>
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) MASConstraint *textViewHeightConstraint;
@property (strong,nonatomic) YYTextView *textView;
@property (strong,nonatomic) NSMutableAttributedString *contentText;

//添加图片的工具栏
@property (strong,nonatomic) UIView *addImageVideoToolView;
@property (strong,nonatomic) UIButton *addImageBtn;//添加照片按钮
@property (strong,nonatomic) UIButton *addVideoBtn;//添加视频按钮
@property (strong,nonatomic) UIButton *keyboardHideBtn;//键盘收起按钮

@property (strong,nonatomic) UIView *downView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //添加键盘通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [self setupViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -Private Methods
-(void)setupViews{
    _scrollView = ({
        UIScrollView *scrollView = [[UIScrollView alloc]init];
        scrollView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:scrollView];
        [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top).offset(20);
            make.bottom.left.right.equalTo(self.view);
        }];
        
        scrollView;
    });
    
    _contentView = ({
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor grayColor];
        [_scrollView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_scrollView);
            make.width.equalTo(@(SCREEN_WIDTH));
        }];
        
        view;
    });
    
    _textView = ({
        YYTextView *textView = [YYTextView new];
        textView.font = [UIFont systemFontOfSize:17];
        textView.backgroundColor = [UIColor grayColor];
        textView.delegate = self;
        [_contentView addSubview:textView];
        [textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(_contentView).insets(UIEdgeInsetsMake(0, 10, 0, 10));
            _textViewHeightConstraint =  make.height.equalTo(@(500./2));
            make.width.equalTo(@(SCREEN_WIDTH - 20));
        }];
        textView;
    });
    

  
    _addImageVideoToolView = ({
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor greenColor];
        [_contentView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_textView.mas_bottom);
            make.left.equalTo(_contentView);
            make.width.equalTo(_contentView);
            make.height.equalTo(@75);
        }];
        view;
    });
    
    _addImageBtn = ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        [btn setTitle:@"加图片" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor redColor];
        [_addImageVideoToolView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.left.equalTo(_addImageVideoToolView);
            make.width.equalTo(@50);
        }];
        [btn addTarget:self action:@selector(addImageBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        btn;
    });
    
    _addVideoBtn = ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.backgroundColor = [UIColor yellowColor];
        [_addImageVideoToolView addSubview:btn];
        [btn setTitle:@"加视频" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(_addImageVideoToolView);
            make.left.equalTo(_addImageBtn.mas_right).offset(10);
            make.width.equalTo(@50);
        }];
        [btn addTarget:self action:@selector(addVideoBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        btn;
    });
    
    _keyboardHideBtn = ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        [btn setTitle:@"键盘收起" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor blueColor];
        [_addImageVideoToolView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.right.equalTo(_addImageVideoToolView);
            make.width.equalTo(@100);
        }];
        [btn addTarget:self action:@selector(keyboardHideBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        btn;
    });


    _downView = ({
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor orangeColor];
        [_contentView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_addImageVideoToolView.mas_bottom);
            make.left.equalTo(_contentView);
            make.bottom.equalTo(_contentView);
            make.width.equalTo(_contentView);
            make.height.equalTo(@200);
        }];
        view;
    });
    
    UILabel *downViewLabel = [UILabel new];
    downViewLabel.text = @"底部其他区域";
    downViewLabel.textAlignment = NSTextAlignmentCenter;
    downViewLabel.font = [UIFont systemFontOfSize:34];
    downViewLabel.textColor = [UIColor blackColor];
    [_downView addSubview:downViewLabel];
    [downViewLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_downView);
    }];

    
}


#pragma mark - YYTextViewDelegate
- (void)textViewDidChange:(YYTextView *)textView{
//    NSLog(@"TEXT= %@",textView.attributedText.string);
//    
//    //获取图片资源
//    NSArray *attachments =  textView.textLayout.attachments;
//    for(YYTextAttachment *attachment in attachments)
//    {
//        UIView *view = attachment.content;
//        UIImageView *imageView = view.subviews[0];
//        UIImage *image = (UIImage *)imageView.image;
//        NSLog(@"获取到图片:%@",image);
//    }
//    
//    NSArray *attachmentRanges = _textView.textLayout.attachmentRanges;
//    for (NSValue *range in attachmentRanges)
//    {
//        NSRange r = [range rangeValue];
//        NSLog(@"资源所在位置：%ld 长度: %ld",r.location,r.length);
//    }
}

#pragma mark - Responding to keyboard events
- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];//键盘高度
    _textViewHeightConstraint.equalTo(@(SCREEN_HEIGHT-20-75-keyboardRect.size.height));
    [_contentView setNeedsUpdateConstraints];
    [_contentView updateConstraintsIfNeeded];
    [_contentView layoutIfNeeded];
}
- (void)keyboardWillHide:(NSNotification *)notification
{
   

}


#pragma mark - Action
-(void)keyboardHideBtnPressed:(id) sender{
    if(_textView.isFirstResponder){
        [_textView resignFirstResponder];
        [self textViewAdjustMaxSize];
    }
}

-(void)addImageBtnPressed:(id) sender{
   
    UIFont *font = [UIFont systemFontOfSize:17];
 
 
    // 将图片插入到文字中
    NSMutableAttributedString *contentText = [[NSMutableAttributedString alloc] initWithAttributedString:self.textView.attributedText];
    contentText.yy_font =  [UIFont systemFontOfSize:17];
    // 1.获取光标前的文字
    NSMutableAttributedString *preText;
  
    preText = [[NSMutableAttributedString alloc] initWithAttributedString:[contentText attributedSubstringFromRange:NSMakeRange(0, self.textView.selectedRange.location)]];
    
    // 2.获取光标后的文字
    NSMutableAttributedString *nextText;
    if (contentText.length > self.textView.selectedRange.location) {
        nextText = [[NSMutableAttributedString alloc] initWithAttributedString:[contentText attributedSubstringFromRange:NSMakeRange(self.textView.selectedRange.location, contentText.length - preText.length)]];
    }
    
    
    
    UIImage *img = [self imageCompressForWidthScale:[UIImage imageNamed:@"1111.jpg"] targetWidth:SCREEN_WIDTH-20];
    
    UIView *imgBgView = [UIView new];
    imgBgView.frame = CGRectMake(0, 0, SCREEN_WIDTH-25, img.size.height+20);
 
    UIImageView *imageView = [[UIImageView alloc] initWithImage:img];
    imageView.layer.cornerRadius = 12;
    imageView.clipsToBounds = YES;
    imageView.frame = CGRectMake(0, 10,SCREEN_WIDTH-25,img.size.height);
    [imgBgView addSubview:imageView];
    
  
    
    NSMutableAttributedString *attachText = [NSMutableAttributedString yy_attachmentStringWithContent:imgBgView contentMode:UIViewContentModeBottom attachmentSize:imgBgView.frame.size alignToFont:font alignment:YYTextVerticalAlignmentCenter];
    attachText.yy_font = font;
    
    
    [preText appendAttributedString:attachText];
    if (nextText.length > 0) {
        [preText appendAttributedString:nextText];
    }
    _textView.attributedText = preText;
    _textView.selectedRange = NSMakeRange(self.textView.attributedText.length + 1, 0);
    if(!_textView.isFirstResponder){
         [self textViewAdjustMaxSize];
    }
   

}

-(void)addVideoBtnPressed:(id) sender{
    
}


#pragma mark -Private Methods
//将textView设置为包裹内容，frame = contentSize
-(void)textViewAdjustMaxSize{
    CGSize sizeToFit = [_textView sizeThatFits:CGSizeMake(SCREEN_WIDTH-20, MAXFLOAT)];
    CGFloat height = sizeToFit.height <= 500./2 ?500./2 :sizeToFit.height;
    _textView.contentSize = CGSizeMake(SCREEN_WIDTH-20, height);
    _textViewHeightConstraint.equalTo(@(height));
    [_contentView setNeedsUpdateConstraints];
    [_contentView updateConstraintsIfNeeded];
    [_contentView layoutIfNeeded];
}

//指定宽度按比例缩放
-(UIImage *) imageCompressForWidthScale:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth{
    
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = defineWidth;
    CGFloat targetHeight = height / (width / targetWidth);
    CGSize size = CGSizeMake(targetWidth, targetHeight);
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    
    if(CGSizeEqualToSize(imageSize, size) == NO){
        
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
        }
        else{
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        if(widthFactor > heightFactor){
            
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
            
        }else if(widthFactor < heightFactor){
            
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(size);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    if(newImage == nil){
        
        NSLog(@"scale image fail");
    }
    UIGraphicsEndImageContext();
    return newImage;
}



@end
