import UIKit

final class MovieQuizPresenter: QuestionFactoryDelegate {
    let questionsAmount: Int = 10
    private var questionNumberGlobal: Int = 0
    var corrects: Int = 0
    var currentQuestion: QuizeQuestion?
    weak var viewController: MovieQuizViewControllerProtocol?
    private var resultsViewModel = QuizeResultsViewModel(title: "", text: "")
    private var questionFactory: QuestionFactoryProtocol?
    private let moviesLoader = MoviesLoader()
    private let statisticService: StatisticService = StatisticServiceImplementation()

    init(viewController: MovieQuizViewControllerProtocol) {
        self.viewController = viewController
        questionFactory = QuestionFactory(moviesLoader: moviesLoader, delegate: self)
        questionFactory?.loadData()
    }

    // MARK: QuestionFactoryDelegate

    func didLoadDataFromServer() {
        questionFactory?.requestNextQuestion()
    }

    func didFailToLoadData(with error: Error) {
        viewController?.showNetworkError(message: error.localizedDescription)
    }

    func didFailToLoadImage(with error: Error) {
        viewController?.showImageLoadError(message: error.localizedDescription)
    }

    func didReceiveErrorMessageInJSON(errorMessage errorMess: String) {
        viewController?.showJSONErrorMessage(message: errorMess)
    }

    func didReceiveErrorMessage(errorMessage errorMess: String) {
        viewController?.showErrorMessage(message: errorMess)
    }

    func didReceiveNextQuestion(question: QuizeQuestion?) {
        guard
            let question = question
        else {
            questionFactory?.requestNextQuestion()
            return
        }
        self.currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.hideLoadingIndicator()
            self?.viewController?.show(quize: viewModel)
        }
    }

    func yesButtonClicked() {
        didAnswer(isYes: true)
    }

    func noButtonClicked() {
        didAnswer(isYes: false)
    }

    func didAnswer(isCorrectAnswer: Bool) {
        if isCorrectAnswer {
            corrects += 1
        }
    }

    private func didAnswer(isYes: Bool) {
        guard let currentQuestion = currentQuestion else {
            return
        }

        let givenAnswer = isYes

        showAnswerResult(isCorrect: givenAnswer != currentQuestion.correctAnswer)
    }

    func convert(model: QuizeQuestion) -> QuizeStepViewModel {
        return QuizeStepViewModel(
            image: model.image,
            question: model.text,
            questionNumber: "\(questionNumberGlobal + 1)/\(questionsAmount)",
            title: model.title
        )
    }

    func isLastQuestion() -> Bool {
        questionNumberGlobal == questionsAmount
    }

    func resetQuestionIndex() {
        questionNumberGlobal = 0
    }

    func switchToNextQuestion() {
        questionNumberGlobal += 1
    }

    func restartGame() {
        questionNumberGlobal = 0
        corrects = 0
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.showLoadingIndicator()
        }
        questionFactory?.requestNextQuestion()
    }

    func showNextQuestionOrResults() {
        self.switchToNextQuestion()
        if !self.isLastQuestion() {
            DispatchQueue.main.async { [weak self] in
                self?.viewController?.showLoadingIndicator()
            }
            questionFactory?.requestNextQuestion()
        } else {
            if corrects != self.questionsAmount {
                resultsViewModel.title = "Этот раунд окончен!"
            } else {
                resultsViewModel.title = "Потрясающе!"
            }
            statisticService.store(correct: corrects, total: questionsAmount)
            resultsViewModel.text = "Ваш результат: \(corrects)/\(questionsAmount)\n"
            resultsViewModel.text += "Количество сыграных квизов:\(statisticService.gamesCount)\n"
            resultsViewModel.text += "Рекорд: \(statisticService.bestGame.correct)/\(statisticService.bestGame.total) (\(statisticService.bestGame.date.dateTimeString))"
            resultsViewModel.text += "\nСредняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%"
            viewController?.show(quize: resultsViewModel)
            return
        }
    }

    func showAnswerResult(isCorrect: Bool) {
        didAnswer(isCorrectAnswer: isCorrect)
        viewController?.highlightImageBorder(isCorrectAnswer: isCorrect)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.showNextQuestionOrResults()
        }
    }
}
