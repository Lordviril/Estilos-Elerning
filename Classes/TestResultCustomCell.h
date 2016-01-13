//
//  TestResultCustomCell.h
//  eEducation
//
//  Created by Hidden Brains on 11/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TestResultCustomCell : UITableViewCell {
	IBOutlet UILabel *lblQuestionNo,*lblQuestion,*lblScore,*lblAnswer,*lblCurrAnswer;
	IBOutlet UILabel *lblCorrectAns,*lblCorrectAnsValue, *lblScoretext;
	IBOutlet UILabel *lblAnswertext;
	
}
@property(nonatomic,retain)IBOutlet UILabel *lblQuestionNo,*lblQuestion,*lblScore,*lblAnswer,*lblCurrAnswer,*lblScoretext;
@property(nonatomic,retain)IBOutlet UILabel *lblCorrectAns,*lblCorrectAnsValue,*lblAnswertext;
@end
