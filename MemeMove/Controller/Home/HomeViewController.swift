//
//  HomeViewController.swift
//  MemeMove
//
//  Created by Vijay Raj on 22/03/22.
//

import UIKit
import SideMenu

class HomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sidemenuCustomView()
    }
    
    private func makeSettings() -> SideMenuSettings {
        let presentationStyle = SideMenuPresentationStyle.menuSlideIn
        presentationStyle.backgroundColor = .gray
        presentationStyle.presentingEndAlpha = 0.5
        var settings = SideMenuSettings()
        settings.presentationStyle = presentationStyle
        return settings
    }
    
    func sidemenuCustomView() {
        self.navigationController?.navigationBar.isTranslucent = false
        let Menu = storyboard?.instantiateViewController(withIdentifier: "SideMenuViewController") as? SideMenuNavigationController
        Menu?.leftSide = true
        Menu?.settings = makeSettings()
        SideMenuManager.default.leftMenuNavigationController = Menu
        SideMenuManager.default.addPanGestureToPresent(toView: view)
        SideMenuManager.default.addScreenEdgePanGesturesToPresent(toView: view)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let sideMenuNavigationController = segue.destination as? SideMenuNavigationController else { return }
        sideMenuNavigationController.leftSide = true
        sideMenuNavigationController.settings = makeSettings()
    }
    
    @IBAction func toggleButton(_ sender: UIButton) {
        
        SideMenuManager.default.leftMenuNavigationController = storyboard?.instantiateViewController(withIdentifier: "SideMenuViewController") as? SideMenuNavigationController
        var sideMenuSet = SideMenuSettings()
        sideMenuSet.presentationStyle = SideMenuPresentationStyle.viewSlideOutMenuOut
        SideMenuManager.default.menuPresentMode = .menuSlideIn
        sideMenuSet.menuWidth = UIScreen.main.bounds.width * 0.9
        let viewMenuBack : UIView = view.subviews.last!
        SideMenuManager.default.addPanGestureToPresent(toView: navigationController!.navigationBar)
        SideMenuManager.default.addScreenEdgePanGesturesToPresent(toView: view)
    }
    
    
}
