//
//  DetailViewCell.swift
//  kakao_subject
//
//  Created by 김동환 on 2020/03/06.
//  Copyright © 2020 김동환. All rights reserved.
//

import UIKit


class DetailCell: UITableViewCell {

    @IBOutlet weak var tourIMG: UIImageView!
    @IBOutlet weak var tourNameLB: UILabel!
    @IBOutlet weak var tourSummaryLB: UILabel!
    @IBOutlet weak var tourKeywordLB: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func settingTourInformation(name : String, summary : String , keyword : String , image : String){
        DispatchQueue.main.async{ [unowned self] in
            self.tourNameLB.text = name
            self.tourSummaryLB.text = summary
            self.tourKeywordLB.text = keyword
            //image
            let urlStr = "https://github.com/rubenbaca/cs193p_iOS11/blob/master/PlayingCard/PlayingCard/Assets.xcassets/J%E2%99%A6%EF%B8%8F.imageset/jack.jpg"
            

            /*
            if let encoded = urlStr.addingPercentEncoding(withAllowedCharacters : .urlFragmentAllowed) , let myURL = URL(string: encoded){
                print(myURL)
                self.tourIMG.load( url: myURL )
            }
            */
            
            if let myURL = URL(string : urlStr){
                self.tourIMG.load(url : myURL)
            }
            
            
            
        }
    }
    
}
