//
//  prototypeDetailCell.swift
//  kakao_subject
//
//  Created by 김동환 on 2020/03/07.
//  Copyright © 2020 김동환. All rights reserved.
//

import UIKit


class prototypeDetailCell: UITableViewCell {

    @IBOutlet weak var testIMG: UIImageView!
    
    public func settingTourInformation(name : String, summary : String , keyword : String , image : String){
        DispatchQueue.main.async{ [unowned self] in
            //image
            let urlStr = image

            /*
            if let encoded = urlStr.addingPercentEncoding(withAllowedCharacters : .urlFragmentAllowed) , let myURL = URL(string: encoded){
                print(myURL)
                self.tourIMG.load( url: myURL )
            }
            */
            
            if let myURL = URL(string : urlStr){
                self.testIMG.load(url : myURL)
            }

        }
    }
}
