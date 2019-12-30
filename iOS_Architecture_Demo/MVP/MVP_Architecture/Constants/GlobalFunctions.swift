//
//  GlobalFunctions.swift
//  VS_Viper_BaseProj
//
//  Created by Mirant Patel on 31/07/19.
//  Copyright © 2019 Mirant Patel. All rights reserved.
//

import Foundation
import UIKit

func getViewController(StoryBoard: Storyboards, Identifier: ControllerIdentifier) -> UIViewController? {
    
    return UIStoryboard(name: StoryBoard.rawValue, bundle: nil).instantiateViewController(withIdentifier: Identifier.rawValue)
    
}
