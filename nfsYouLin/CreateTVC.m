//
//  CreateTVC.m
//  Test3
//
//  Created by Macx on 16/8/10.
//  Copyright © 2016年 Macx. All rights reserved.
//

#import "CreateTVC.h"
#import "HeaderFile.h"

@implementation CreateTVC
{
    UILabel* limitLabel;

    UIImageView* startIV;
    UIImageView* endIV;
    UIImageView* addressIV;
    
    UILabel* LevelL;
    UIImageView* LevelIV;

    UITextField* _priceTF;
    UIImageView* priceIV;
    NSNumberFormatter* numberFormatter;
    NSCharacterSet* inputCharacterSet;

}

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        if([reuseIdentifier isEqualToString:@"limit"])
        {
            limitLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,2, screenWidth - 35, CGRectGetHeight(self.contentView.frame))];
            limitLabel.font = [UIFont systemFontOfSize:15];
            limitLabel.textAlignment = NSTextAlignmentRight;
            [self.contentView addSubview:limitLabel];
        }
        else if([reuseIdentifier isEqualToString:@"level"])
        {
            UILabel* levelL = [[UILabel alloc] initWithFrame:CGRectMake(0, 2, screenWidth - 35, CGRectGetHeight(self.contentView.frame))];
            levelL.font = [UIFont systemFontOfSize:15];
            levelL.textAlignment = NSTextAlignmentRight;
            LevelL = levelL;
            [self.contentView addSubview:levelL];
            
            UIImageView* emptyIV = [[UIImageView alloc] initWithFrame:CGRectMake(screenWidth - 55, 15, 20, 20)];
            emptyIV.image = [UIImage imageNamed:@"tanhao.png"];
            emptyIV.layer.masksToBounds = YES;
            emptyIV.layer.cornerRadius = 10;
            [self.contentView addSubview:emptyIV];
            LevelIV = emptyIV;
        }
        else if([reuseIdentifier isEqualToString:@"price"])
        {
            inputCharacterSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
            numberFormatter = [[NSNumberFormatter alloc] init];
            numberFormatter.numberStyle = NSNumberFormatterRoundDown;
            [numberFormatter setMinimumFractionDigits:0];
            [numberFormatter setMaximumFractionDigits:0];

            CGFloat priceW = screenWidth - 125;
            UITextField* priceTF = [[UITextField alloc] initWithFrame:CGRectMake(60, 2, priceW, CGRectGetHeight(self.contentView.frame))];
            priceTF.font = [UIFont systemFontOfSize:15];
            priceTF.keyboardType = UIKeyboardTypeNumberPad;
            priceTF.textAlignment = NSTextAlignmentRight;
            priceTF.delegate = self;
            [priceTF setText:[numberFormatter stringFromNumber:[NSNumber numberWithInt:0]]];
            _priceTF = priceTF;
            [self.contentView addSubview:priceTF];
            
            UIImageView* emptyIV = [[UIImageView alloc] initWithFrame:CGRectMake(screenWidth - 55, 15, 20, 20)];
            emptyIV.image = [UIImage imageNamed:@"tanhao.png"];
            emptyIV.layer.masksToBounds = YES;
            emptyIV.layer.cornerRadius = 10;
            [self.contentView addSubview:emptyIV];
             priceIV = emptyIV;

        }
        else if([reuseIdentifier isEqualToString:@"start"])
        {
            
            CGFloat startW = screenWidth - 95;
            UILabel* startL = [[UILabel alloc] initWithFrame:CGRectMake(0, 2, startW, CGRectGetHeight(self.contentView.frame))];
            startL.font = [UIFont systemFontOfSize:15];
            startL.text = @"开始时间";
            startL.enabled = NO;
            startL.textAlignment = NSTextAlignmentRight;
            [self.contentView addSubview:startL];
            self.startL = startL;
            
            UIImageView* emptyIV = [[UIImageView alloc] initWithFrame:CGRectMake(screenWidth - 85, 15, 20, 20)];
            emptyIV.image = [UIImage imageNamed:@"tanhao.png"];
            emptyIV.layer.masksToBounds = YES;
            emptyIV.layer.cornerRadius = 10;
            [self.contentView addSubview:emptyIV];
            startIV = emptyIV;
            
            UIImageView* timeIV = [[UIImageView alloc] initWithFrame:CGRectMake(screenWidth - 55, 15, 20, 20)];
            timeIV.layer.masksToBounds = YES;
            timeIV.layer.cornerRadius = 10;
            timeIV.image = [UIImage imageNamed:@"pic_shijina.png"];
            [self.contentView addSubview:timeIV];
        }
        else if([reuseIdentifier isEqualToString:@"end"])
        {
            CGFloat endW = screenWidth - 95;
            UILabel* endL = [[UILabel alloc] initWithFrame:CGRectMake(0, 2, endW, CGRectGetHeight(self.contentView.frame))];
            endL.font = [UIFont systemFontOfSize:15];
            endL.text = @"结束时间";
            endL.enabled = NO;
            endL.textAlignment = NSTextAlignmentRight;
            [self.contentView addSubview:endL];
            self.endL = endL;
            
            UIImageView* emptyIV = [[UIImageView alloc] initWithFrame:CGRectMake(screenWidth - 85, 15, 20, 20)];
            emptyIV.image = [UIImage imageNamed:@"tanhao.png"];
            emptyIV.layer.masksToBounds = YES;
            emptyIV.layer.cornerRadius = 10;
            [self.contentView addSubview:emptyIV];
            endIV = emptyIV;
            
            UIImageView* timeIV = [[UIImageView alloc] initWithFrame:CGRectMake(screenWidth - 55, 15, 20, 20)];
            timeIV.layer.masksToBounds = YES;
            timeIV.layer.cornerRadius = 10;
            timeIV.image = [UIImage imageNamed:@"pic_shijina.png"];
            [self.contentView addSubview:timeIV];
        }
        else if([reuseIdentifier isEqualToString:@"address"])
        {
            CGFloat addressW = screenWidth - 165;
            UILabel* addressL = [[UILabel alloc] initWithFrame:CGRectMake(100, 2, addressW, CGRectGetHeight(self.contentView.frame))];
            addressL.font = [UIFont systemFontOfSize:15];
            addressL.numberOfLines = 2;
            addressL.text = @"详细地址";
            addressL.enabled = NO;
            addressL.textAlignment = NSTextAlignmentRight;
            [self.contentView addSubview:addressL];
            self.addressL = addressL;
            
            UIImageView* emptyIV = [[UIImageView alloc] initWithFrame:CGRectMake(screenWidth - 55, 15, 20, 20)];
            emptyIV.image = [UIImage imageNamed:@"tanhao.png"];
            emptyIV.layer.masksToBounds = YES;
            emptyIV.layer.cornerRadius = 10;
            [self.contentView addSubview:emptyIV];
            addressIV = emptyIV;
        }

        
    }
    
    return self;
}

- (void) setWhere:(NSInteger )where
{
    _where = where;
    switch (where) {
        case 0:
            limitLabel.text = @"本小区";
            break;
        case 1:
            limitLabel.text = @"周边";
            break;
        case 2:
            limitLabel.text = @"同城";
            break;
            
        default:
            break;
    }
}


- (void) setStartB:(BOOL)startB
{
    _startB = startB;

    if(_startB)
    {
        CGRect rect = self.startL.frame;
        rect.size.width = screenWidth - 65;
        self.startL.frame = rect;
        startIV.hidden = YES;
    }
    else
    {
        CGRect rect = self.startL.frame;
        rect.size.width = screenWidth - 95;
        self.startL.frame = rect;
        startIV.hidden = NO;
    }
}


- (void)setEndB:(BOOL)endB
{
    _endB = endB;
    if(_endB)
    {
        CGRect rect = self.endL.frame;
        rect.size.width = screenWidth - 65;
        self.endL.frame = rect;
        endIV.hidden = YES;
    }
    else
    {
        CGRect rect = self.endL.frame;
        rect.size.width = screenWidth - 95;
        self.endL.frame = rect;
        endIV.hidden = NO;
    }
    
}

- (void)setAddressB:(BOOL)addressB
{
    _addressB = addressB;
    if(_addressB)
    {
        CGRect rect = self.addressL.frame;
        rect.size.width = screenWidth - 135;
        self.addressL.frame = rect;
        addressIV.hidden = YES;
    }
    else
    {
        CGRect rect = self.addressL.frame;
        rect.size.width = screenWidth - 165;
        self.addressL.frame = rect;
        addressIV.hidden = NO;
    }
}

- (void)setPriceB:(BOOL)priceB
{
    _priceB = priceB;
    if(_priceB)
    {
        CGRect rect = _priceTF.frame;
        rect.size.width = screenWidth - 95;
        _priceTF.frame = rect;
        priceIV.hidden = YES;
    }
    else
    {
        CGRect rect = _priceTF.frame;
        rect.size.width = screenWidth - 125;
        _priceTF.frame = rect;
        priceIV.hidden = NO;
    }

}

- (void)setLevel:(NSInteger)level
{
    _level = level;
    if(level == -2)
    {
        LevelIV.hidden = NO;
        return;
    }
    
    LevelIV.hidden = YES;
    switch (level) {
        case -1:
        {
            LevelL.text = @"";
            break;
        }
        case 0:
        {
            LevelL.text = @"全新";
            break;
        }
        case 1:
        {
            LevelL.text = @"九成新";
            break;
        }
        case 2:
        {
            LevelL.text = @"八成新";
            break;
        }
        case 3:
        {
            LevelL.text = @"七成新";
            break;
        }
        case 4:
        {
            LevelL.text = @"六成新";
            break;
        }
        case 5:
        {
            LevelL.text = @"五成新";
            break;
        }
        case 6:
        {
            LevelL.text = @"五成新以下";
            break;
        }
        default:
            break;
    }

}


- (void) setCaratPosition: (NSInteger) pos
{
    [self setSelectionRange: NSMakeRange(pos, 0)];
}

- (void) setSelectionRange: (NSRange) range
{
    UITextPosition *start = [_priceTF positionFromPosition: [_priceTF beginningOfDocument] offset: range.location];
    UITextPosition *end = [_priceTF positionFromPosition: start offset: range.length];
    [_priceTF setSelectedTextRange: [_priceTF textRangeFromPosition:start toPosition:end]];
}


#pragma mark -UITextFieldDelegate

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if(!self.priceB)
    {
        self.priceB = YES;
    }
    
    if (string.length == 0 && range.length == 1 && [inputCharacterSet characterIsMember: [textField.text characterAtIndex: range.location]] )
    {
        [self setCaratPosition: range.location];
        return NO;
    }
    NSInteger distanceFromEnd = textField.text.length - (range.location + range.length);
    NSString* changed = [textField.text stringByReplacingCharactersInRange: range withString: string];
    NSString* digitString = [[changed componentsSeparatedByCharactersInSet: inputCharacterSet] componentsJoinedByString: @""];
    if(changed.length == 0)
    {
        [textField setText:[numberFormatter stringFromNumber:[NSNumber numberWithInt:0]]];
        [_delegate getPrice:0];
    }
    else
    {
        if(digitString.length > 11)
        {
            return NO;
        }
        [textField setText:[numberFormatter stringFromNumber:[NSNumber numberWithInteger:digitString.integerValue]]];
        [_delegate getPrice:digitString.integerValue];
    }
    NSInteger pos = textField.text.length - distanceFromEnd;
    if ( pos >= 0 && pos <= textField.text.length )
    {
        [self setCaratPosition:pos];
    }
    return NO;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
