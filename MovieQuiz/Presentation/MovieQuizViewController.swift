import UIKit
import SkeletonView

final class MovieQuizViewController: UIViewController {
    //MARK: - Private properties
    private lazy var presenter: MovieQuizPresenter = {
        MovieQuizPresenter(viewController: self)
    }()
    
    //MARK: - Private outlets
    @IBOutlet weak var questionNumber: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var questionLeftLabel: UILabel!
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareOutletsToAnimate()
        
        showLoadingIndicator()
        showSkeleton()
        
        presenter.loadData()
    }
    
    //MARK: - Private functions
    @MainActor
    private func showSkeleton() {
        let gradient = SkeletonGradient(baseColor: UIColor.midnightBlue)
        
        imageView.showAnimatedGradientSkeleton(usingGradient: gradient)
        questionLabel.showAnimatedGradientSkeleton(usingGradient: gradient)
        questionNumber.showAnimatedGradientSkeleton(usingGradient: gradient)
        questionLeftLabel.showAnimatedGradientSkeleton(usingGradient: gradient)
        yesButton.showAnimatedGradientSkeleton(usingGradient: gradient)
        noButton.showAnimatedGradientSkeleton(usingGradient: gradient)
    }
    
    @MainActor
    func hideSkeleton() {
        imageView.hideSkeleton()
        questionLabel.hideSkeleton()
        questionNumber.hideSkeleton()
        questionLeftLabel.hideSkeleton()
        yesButton.hideSkeleton()
        noButton.hideSkeleton()
    }
    
    private func prepareOutletsToAnimate() {
        imageView.isSkeletonable = true
        imageView.skeletonCornerRadius = 20
        questionLabel.isSkeletonable = true
        questionNumber.isSkeletonable = true
        questionLeftLabel.isSkeletonable = true
        yesButton.isSkeletonable = true
        yesButton.skeletonCornerRadius = 15
        noButton.isSkeletonable = true
        noButton.skeletonCornerRadius = 15
    }
    
    func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func hideLoadingIndicator() {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    func show(quiz step: QuizStepViewModel) {
        questionNumber.text = step.questionNumber
        imageView.image = step.image
        questionLabel.text = step.question
    }
    
    func showAnswerResult(isCorrect: Bool) {
        imageView.layer.borderWidth = 8
        
        imageView.layer.borderColor = isCorrect ? UIColor(resource: .appGreen).cgColor : UIColor(resource: .appRed).cgColor
        
        Task { @MainActor [weak self] in
            try? await Task.sleep(nanoseconds: 1_000_000_000)
            self?.presenter.showNextQuestionOrResult()
            self?.imageView.layer.borderWidth = 0
        }
    }
    
    //MARK: - Private actions
    @IBAction private func noButtonTapped(_ sender: UIButton) {
        presenter.noButtonTapped()
    }
    
    @IBAction private func yesButtonTapped(_ sender: UIButton) {
        presenter.yesButtonTapped()
    }
}
