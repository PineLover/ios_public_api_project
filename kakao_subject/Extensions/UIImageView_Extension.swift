//
//  UIImageView_Extensino.swift
//  kakao_subject
//
//  Created by 김동환 on 2020/03/07.
//  Copyright © 2020 김동환. All rights reserved.
//
import UIKit

extension UIImageView{
    func load(url : URL){
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                
                if let image = UIImage(data: data){
    
                    DispatchQueue.main.async{
                        self?.image = image

                    }
                }else{
                    print("UIImage not working")
                }
            }
        }
    }
}
