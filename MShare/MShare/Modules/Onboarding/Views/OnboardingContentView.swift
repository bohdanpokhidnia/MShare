//
//  OnboardingContentView.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 20.01.2023.
//

import UIKit

final class OnboardingContentView: View {
    
    // MARK: - UI
    
    private var backgroundImageView = UIImageView(image: .init(named: "onboarding"))
    
    private(set) var containerPageController = View()
    
    private(set) lazy var pageController = UIPageViewController(
        transitionStyle: .scroll,
        navigationOrientation: .horizontal,
        options: nil
    ).make {
        $0.dataSource = self
        $0.delegate = self
    }
    
    private let controlsContainerView = View()
    
    private lazy var pageControl = UIPageControl()
        .make {
            $0.numberOfPages = pages.count
            $0.isUserInteractionEnabled = false
        }
    
    private lazy var startUseButton = Button(type: .custom)
        .setTitle("Start use")
        .set(font: .onboardingAction)
        .setTitleColor(.systemBlue, forState: .normal)
        .setTitleColor(.systemBlue.withAlphaComponent(0.7), forState: .highlighted)
        .backgroundColor(color: .white)
        .setCornerRadius(8)
        .maskToBounds(true)
        .whenTap {
            print("[dev] did tap start use")
        }
    
    // MARK: - Lifecycle

    override func setupSubviews() {
        super.setupSubviews()
        
        addSubviews(
            backgroundImageView,
            controlsContainerView,
            containerPageController,
            pageControl,
            startUseButton
        )
        
        pageController.setViewControllers([pages.first!], direction: .forward, animated: true)
    }
    
    override func defineLayout() {
        super.defineLayout()
        
        backgroundImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        containerPageController.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        controlsContainerView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(200)
        }
        
        pageControl.snp.makeConstraints {
            $0.top.equalTo(controlsContainerView)
            $0.centerX.equalToSuperview()
        }
        
        startUseButton.snp.makeConstraints {
            $0.top.equalTo(pageControl.snp.bottom).inset(UIEdgeInsets(aBottom: -16))
            $0.leading.trailing.equalToSuperview().inset(UIEdgeInsets(horizontal: 16))
            $0.height.equalTo(48)
        }
    }
    
    // MARK: - Private
    
    private lazy var pages = [FirstPageViewController(),
                              TwoPageViewController(),
                              ThirdPageViewController()]
    
}

// MARK: - UIPageViewControllerDataSource

extension OnboardingContentView: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: viewController) else { return nil }
        let prevIndex = currentIndex - 1
        guard prevIndex >= 0 else { return nil }
        
        return pages[prevIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: viewController) else { return nil }
        let nextIndex = currentIndex + 1
        guard nextIndex < pages.count else { return nil }
        
        return pages[nextIndex]
    }
    
}

// MARK: - UIPageViewControllerDelegate

extension OnboardingContentView: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool) {
        guard let currentViewController = pageViewController.viewControllers?.last,
              let currentIndex = pages.firstIndex(of: currentViewController)
        else { return }
        
        pageControl.currentPage = currentIndex
    }
    
}
