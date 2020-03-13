//
//  ConnectViewController.swift
//  kakao_subject
//
//  Created by 김동환 on 2020/03/08.
//  Copyright © 2020 김동환. All rights reserved.
//

import UIKit

class ConnectViewController: UIViewController {

    
    @IBOutlet weak var locationAutorityV: RoundView!
    @IBOutlet weak var outlineAppMarkV: UIView!{
        didSet{
            outlineAppMarkV.layer.borderWidth = 3
            outlineAppMarkV.layer.borderColor = UIColor.white.cgColor
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()


        
        // Do any additional setup after loading the view.
        showOutlineAnimation()
    }
    

    
    // MARK: - Method
    //where should i call this?
    private func transferNextStoryBoard(name: String){
        guard let nextController = UIStoryboard(name : name, bundle: nil).instantiateInitialViewController() else{
            fatalError("could not load UIstoryBoard")
        }
        self.present(nextController, animated: true , completion: nil)
    }

    //ok it worked
    private func showOutlineAnimation(){
        UIView.animate(withDuration: 3, delay: 0.3, options: [], animations: {
            [unowned self] in
            
            self.outlineAppMarkV.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
            
            }, completion: { [unowned self] (_) in
                self.showLocationButton()
        })
    }
    
    private func showLocationButton(){
        UIView.animate(withDuration : 0.5 , delay: 0.4 , options : [] , animations: {
            [unowned self] in
            self.locationAutorityV.isHidden = false
            
        }, completion:  nil )
    }

    //MARK: - action method
    @IBAction func acquireLocation(_ sender: UIButton) {
        self.locationAutorityV.isHidden = true
        CLocation.locationInstance.delegate = self
        CLocation.locationInstance.settingLocationManager()
    }
    
    
}

//MARK: - ConnectViewController Delegate Extension
extension ConnectViewController: AlarmGetLocation{
    func alarmGetLocation() {
        UserDefaults.standard.set(true, forKey: LOCATION_ACQUIRE_KEY)
        transferNextStoryBoard(name: "Main")
        

        let location = CLocation.locationInstance.getCurrentLocation()
        //why getting default location at first time??? 아 알았다. 여기서는 세팅이 되고 나서 출력하는게 아니라 처음 값으로 출력하네???
        print("current Location : \(location.latitude) , \(location.longitude)")
        //print("current address : \(CLocation.locationInstance.getCurrentAddress())")
    }
}
