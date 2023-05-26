//
//  OnboardingFactory.swift
//  Volrota
//
//  Created by Greg Zenkov on 5/14/23.
//

import UIKit
import GeneralServices

final class OnboardingFactory {
    
    func build(with version: OnboardingVersion) -> [UIViewController] {
        switch version {
        case .v1_1:
            return createOnboardingPages_v1_1()
        case .v1_2:
            return createOnboardingPages_v1_2()
        }
    }
    
    private func createOnboardingPages_v1_1() -> [UIViewController] {
        var pages = [UIViewController]()
        let pageModel = Onboarding_v1_1_Model(
            animationName: "envelope",
            titleText: "Включите уведомления, чтобы быть в курсе последних новостей. Доступ к уведомлениям можно редактироать в настройках."
        )
        let pageViewController = Onboarding_v1_1_Page(model: pageModel)
        pages.append(pageViewController)
        
        return pages
    }
    
    private func createOnboardingPages_v1_2() -> [UIViewController] {
        var pages = [UIViewController]()
        let pageModel = Onboarding_v1_2_Model(
            titleText: "Включите уведомления, чтобы быть в курсе последних новостей.",
            descriptionText: "Достпу к уведомлениям можно редактироать в настройках.",
            image: Images.volhubLogo.image
        )
        let pageViewController = Onboarding_v1_2_Page(model: pageModel)
        pages.append(pageViewController)
        
        return pages
    }
}
