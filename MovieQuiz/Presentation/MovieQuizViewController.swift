import UIKit

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {
    @IBOutlet private var moviePoster: UIImageView!
    @IBOutlet private var questionForUser: UILabel!
    @IBOutlet private var questionNumber: UILabel!
    @IBOutlet private var noButton: UIButton!
    @IBOutlet private var yesButton: UIButton!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private var movieTitle: UILabel!

    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter.noButtonClicked()
    }
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter.yesButtonClicked()
    }

    private var currentViewModel = QuizeStepViewModel(image: Data(), question: "", questionNumber: "", title: "")
    private var buttonsBlocked = false
    private let greenColor: CGColor = UIColor(named: "YCGreen")!.cgColor
    private let redColor: CGColor = UIColor(named: "YCRed")!.cgColor
    private var presenter: MovieQuizPresenter!

    func showLoadingIndicator() {
        DispatchQueue.main.async {
            self.movieTitle.isHidden = true
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
        }
    }

    func hideLoadingIndicator() {
        DispatchQueue.main.async {
            self.activityIndicator.isHidden = true
            self.activityIndicator.stopAnimating()
        }
    }

    func showNetworkError(message: String) {
        hideLoadingIndicator()
        let alert = ResultAlertPresenter(
            title: "Ошибка сети",
            message: message,
            buttonText: "OK",
            controller: self,
            actionHandler: { _ in }
        )
        DispatchQueue.main.async {
            alert.show()
        }
    }

    func showImageLoadError(message: String) {
        let alert = ResultAlertPresenter(
            title: "Ошибка загрузки изображения",
            message: message,
            buttonText: "OK",
            controller: self,
            actionHandler: { _ in }
        )
        DispatchQueue.main.async {
            self.movieTitle.isHidden = false
            alert.show()
        }
    }

    func showJSONErrorMessage(message: String) {
        let alert = ResultAlertPresenter(
            title: "Ошибка в полученных данных",
            message: message,
            buttonText: "OK",
            controller: self,
            actionHandler: { _ in }
        )
        DispatchQueue.main.async {
            self.movieTitle.isHidden = false
            alert.show()
        }
    }

    func showErrorMessage(message: String) {
        let alert = ResultAlertPresenter(
            title: "Ошибка",
            message: message,
            buttonText: "OK",
            controller: self,
            actionHandler: { _ in }
        )
        DispatchQueue.main.async {
            self.movieTitle.isHidden = false
            alert.show()
        }
    }

    func show(quize step: QuizeStepViewModel) {
        moviePoster.layer.borderWidth = 0
        currentViewModel = step
        moviePoster.image = UIImage(data: currentViewModel.image)
        questionForUser.text = currentViewModel.question
        questionNumber.text = currentViewModel.questionNumber
        yesButton.isEnabled = true
        noButton.isEnabled = true
        hideLoadingIndicator()
        movieTitle.text = "Наименование фильма:\n\(currentViewModel.title)"
    }

    func show(quize result: QuizeResultsViewModel) {
        presenter.corrects = 0
        presenter.resetQuestionIndex()

        let alert = ResultAlertPresenter(
            title: result.title,
            message: result.text,
            buttonText: "Сыграть еще раз!",
            controller: self,
            actionHandler: { _ in
                self.showLoadingIndicator()
                self.presenter.restartGame()
            }
        )
        DispatchQueue.main.async {
            alert.show()
        }
    }

    func highlightImageBorder(isCorrectAnswer: Bool) {
        yesButton.isEnabled = false
        noButton.isEnabled = false
        moviePoster.layer.borderWidth = 8
        moviePoster.layer.borderColor = isCorrectAnswer ? greenColor : redColor
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.moviePoster.layer.masksToBounds = true
        self.moviePoster.layer.borderWidth = 0
        self.moviePoster.layer.borderColor = UIColor.white.cgColor
        self.moviePoster.layer.cornerRadius = 20
        self.movieTitle.isHidden = true
        presenter = MovieQuizPresenter(viewController: self)
    }

    // MARK: QuestionFactoryDelegate
    func didReceiveNextQuestion(question: QuizeQuestion?) {
        presenter.didReceiveNextQuestion(question: question)
    }
}
