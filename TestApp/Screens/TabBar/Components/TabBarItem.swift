import UIKit
import Foundation

class TabBarItem: UITabBarItem {
    let tab_title: String
    let tab_image: UIImage
    let tab_selectable_image: UIImage
    
    init(title: String, image: UIImage, selectableImage: UIImage) {
        self.tab_title = title
        self.tab_image = image
        self.tab_selectable_image = selectableImage
        super.init()
        
        self.title = title
        self.image = image
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
