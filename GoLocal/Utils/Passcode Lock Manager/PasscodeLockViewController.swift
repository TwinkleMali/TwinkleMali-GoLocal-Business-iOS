//
//  PasscodeLockViewController.swift
//  PasscodeLock
//
//  Created by Yanko Dimitrov on 8/28/15.
//  Copyright © 2015 Yanko Dimitrov. All rights reserved.
//

import UIKit

open class PasscodeLockViewController: UIViewController, PasscodeLockTypeDelegate {
    public enum LockState {
        case enter
        case set
        case change
        case remove

        func getState() -> PasscodeLockStateType {
            switch self {
                case .enter: return EnterPasscodeState()
                case .set: return SetPasscodeState()
                case .change: return ChangePasscodeState()
                case .remove: return RemovePasscodeState()
            }
        }
    }

    private static var nibName: String { return "PasscodeLockView" }

    open class var nibBundle: Bundle {
        return bundleForResource(name: nibName, ofType: "nib")
    }

    @IBOutlet open var placeholders: [PasscodeSignPlaceholderView] = [PasscodeSignPlaceholderView]()
    @IBOutlet open weak var titleLabel: UILabel?
    @IBOutlet open weak var descriptionLabel: UILabel?
    @IBOutlet open weak var cancelButton: UIButton?
    @IBOutlet open weak var deleteSignButton: UIButton?
    @IBOutlet open weak var touchIDButton: UIButton?
    @IBOutlet open weak var placeholdersX: NSLayoutConstraint?
    @IBOutlet open weak var forgotButton: UIButton!
    
    open var successCallback: ((_ lock: PasscodeLockType) -> Void)?
    open var dismissCompletionCallback: (() -> Void)?
    
    open var animateOnDismiss: Bool
    open var notificationCenter: NotificationCenter?
    
    internal let passcodeConfiguration: PasscodeLockConfigurationType
    internal var passcodeLock: PasscodeLockType
    internal var isPlaceholdersAnimationCompleted = true

    private var shouldTryToAuthenticateWithBiometrics = true

    fileprivate var completionHandler: (AlertResult) -> () = {result  in }
    var isForCancelOption = false
    // MARK: - Initializers

    public init(state: PasscodeLockStateType, configuration: PasscodeLockConfigurationType, animateOnDismiss: Bool = true) {
        self.animateOnDismiss = animateOnDismiss

        passcodeConfiguration = configuration
        passcodeLock = PasscodeLock(state: state, configuration: configuration)

        let this = type(of: self)
        super.init(nibName: this.nibName, bundle: this.nibBundle)

        passcodeLock.delegate = self
        notificationCenter = NotificationCenter.default
    }

    public convenience init(state: LockState, configuration: PasscodeLockConfigurationType, animateOnDismiss: Bool = true) {
        self.init(state: state.getState(), configuration: configuration, animateOnDismiss: animateOnDismiss)
    }

    public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        clearEvents()
    }

    // MARK: - View

    open override func viewDidLoad() {
        super.viewDidLoad()

        updatePasscodeView()
        deleteSignButton?.isEnabled = false

        cancelButton?.setTitle("Cancel", for: .normal)
        deleteSignButton?.setTitle("Delete", for: .normal)

        setupEvents()
    }

    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if shouldTryToAuthenticateWithBiometrics {
            authenticateWithTouchID()
        }
    }
    open override func viewWillAppear(_ animated: Bool) {
        print(">>LOCK Appear")
    }
    open override func viewDidDisappear(_ animated: Bool) {
        print(">>LOCK Disppear..")
    }
    open override func viewWillDisappear(_ animated: Bool) {
        print(">>LOCK Disppear")
    }
    internal func updatePasscodeView() {
        titleLabel?.text = passcodeLock.state.title
        descriptionLabel?.text = passcodeLock.state.description
        touchIDButton?.isHidden = !passcodeLock.isTouchIDAllowed
        let repository = UserDefaultsPasscodeRepository()
        //        configuration = PasscodeLockConfiguration(repository: repository)
        self.forgotButton.isHidden = !repository.hasPasscode
        if isForCancelOption {
            cancelButton?.isHidden = false
        } else {
            cancelButton?.isHidden = !passcodeLock.state.isCancellableAction
        }
    }

    // MARK: - Events

    private func setupEvents() {
        notificationCenter?.addObserver(self, selector: #selector(PasscodeLockViewController.appWillEnterForegroundHandler(_:)), name: UIApplication.willEnterForegroundNotification, object: nil)
        notificationCenter?.addObserver(self, selector: #selector(PasscodeLockViewController.appDidEnterBackgroundHandler(_:)), name: UIApplication.didEnterBackgroundNotification, object: nil)
    }

    private func clearEvents() {
        notificationCenter?.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
        notificationCenter?.removeObserver(self, name: UIApplication.didEnterBackgroundNotification, object: nil)
    }

    @objc open func appWillEnterForegroundHandler(_ notification: Notification) {
        authenticateWithTouchID()
    }

    @objc open func appDidEnterBackgroundHandler(_ notification: Notification) {
        shouldTryToAuthenticateWithBiometrics = false
    }

    func setHandler(isforCancel:Bool,  completion: @escaping (AlertResult) -> ()){
        completionHandler = completion
        isForCancelOption = isforCancel
    }

    // MARK: - Actions

    @IBAction func passcodeSignButtonTap(_ sender: PasscodeSignButton) {
        guard isPlaceholdersAnimationCompleted else { return }

        passcodeLock.addSign(sender.passcodeSign)
    }

    @IBAction func cancelButtonTap(_ sender: UIButton) {
        dismissPasscodeLock(passcodeLock)
    }

    @IBAction func resetPinButtonTap(_ sender: Any) {
        let vc = ForgotPasswordViewController.loadFromNib()
        vc.modalPresentationStyle = .overFullScreen
        vc.isForLoginPin = true
        self.present(vc, animated: true, completion: nil)
    }
    @IBAction func deleteSignButtonTap(_ sender: UIButton) {
        passcodeLock.removeSign()
    }

    @IBAction func touchIDButtonTap(_ sender: UIButton) {
        passcodeLock.authenticateWithTouchID()
    }

    private func authenticateWithTouchID() {
        if passcodeConfiguration.shouldRequestTouchIDImmediately && passcodeLock.isTouchIDAllowed {
            passcodeLock.authenticateWithTouchID()
        }
    }

    internal func dismissPasscodeLock(_ lock: PasscodeLockType, completionHandler: (() -> Void)? = nil) {
        // if presented as modal
        if presentingViewController?.presentedViewController == self {
            dismiss(animated: animateOnDismiss) { [weak self] in
                self?.dismissCompletionCallback?()
                self?.completionHandler(.failure)
                completionHandler?()
            }
        } else {
            // if pushed in a navigation controller
            _ = navigationController?.popViewController(animated: animateOnDismiss)
            dismissCompletionCallback?()
            self.completionHandler(.failure)
            completionHandler?()
        }
    }

    // MARK: - Animations

    internal func animateWrongPassword() {
        deleteSignButton?.isEnabled = false
        isPlaceholdersAnimationCompleted = false

        animatePlaceholders(placeholders, toState: .error)

        placeholdersX?.constant = -40
        view.layoutIfNeeded()

        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            usingSpringWithDamping: 0.2,
            initialSpringVelocity: 0,
            options: [],
            animations: {
                self.placeholdersX?.constant = 0
                self.view.layoutIfNeeded()
            },
            completion: { completed in
                self.isPlaceholdersAnimationCompleted = true
                self.animatePlaceholders(self.placeholders, toState: .inactive)
            }
        )
    }

    internal func animatePlaceholders(_ placeholders: [PasscodeSignPlaceholderView], toState state: PasscodeSignPlaceholderView.State) {
        placeholders.forEach { $0.animateState(state) }
    }

    private func animatePlacehodlerAtIndex(_ index: Int, toState state: PasscodeSignPlaceholderView.State) {
        guard index < placeholders.count && index >= 0 else { return }

        placeholders[index].animateState(state)
    }

    // MARK: - PasscodeLockDelegate

    open func passcodeLockDidSucceed(_ lock: PasscodeLockType) {
        deleteSignButton?.isEnabled = true
        animatePlaceholders(placeholders, toState: .inactive)

        dismissPasscodeLock(lock) { [weak self] in
            self?.successCallback?(lock)
            self?.completionHandler(.success)
        }
    }

    open func passcodeLockDidFail(_ lock: PasscodeLockType) {
        animateWrongPassword()
    }

    open func passcodeLockDidChangeState(_ lock: PasscodeLockType) {
        updatePasscodeView()
        animatePlaceholders(placeholders, toState: .inactive)
        deleteSignButton?.isEnabled = false
    }

    open func passcodeLock(_ lock: PasscodeLockType, addedSignAt index: Int) {
        animatePlacehodlerAtIndex(index, toState: .active)
        deleteSignButton?.isEnabled = true
    }

    open func passcodeLock(_ lock: PasscodeLockType, removedSignAt index: Int) {
        animatePlacehodlerAtIndex(index, toState: .inactive)

        if index == 0 {
            deleteSignButton?.isEnabled = false
        }
    }
}
