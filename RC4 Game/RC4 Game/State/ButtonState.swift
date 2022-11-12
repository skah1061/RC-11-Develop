//
//  ButtonState.swift
//  RC4 Game
//
//  Created by 강정훈 on 2022/11/09.
//

import Foundation
import UIKit

class ButtonState:UIButton{
    
    var isSelect: Bool = false
    let activeImage = UIImage(systemName: "checkmark.circle.fill")
    let deActiveImage = UIImage(systemName: "checkmark.circle")
    
    func setState(){
        
        self.setImage(self.isSelect ?  activeImage : deActiveImage, for: .normal)
    }
}

