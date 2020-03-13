//
//  RoundView.swift
//  kakao_subject
//
//  Created by 김동환 on 2020/03/08.
//  Copyright © 2020 김동환. All rights reserved.
//

import UIKit

@IBDesignable
class RoundView : UIView{
    override func layoutSubviews() {
        //self.layer.masksToBounds = false
        self.layer.cornerRadius = self.frame.height/2
        //layer.masksToBounds < clipsToBounds (wins)
        self.clipsToBounds = true
    }
}
