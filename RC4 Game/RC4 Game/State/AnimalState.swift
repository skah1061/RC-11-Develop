//
//  AnimalState.swift
//  RC4 Game
//
//  Created by 강정훈 on 2022/11/10.
//

import Foundation
import UIKit

class AnimalState{
    
    var speed: Int = 0
    var name: String = "개"
    var potential: Int = 0
    var sleep: Int = 0
    
    var image1: UIImage
    var image2: UIImage
       
    init(speed: Int, name: String, potential: Int, sleep: Int, image1: UIImage, image2: UIImage) {
        self.speed = speed
        self.name = name
        self.potential = potential
        self.sleep = sleep
        
        self.image1 = image1
        self.image2 = image2
    }
    
}
