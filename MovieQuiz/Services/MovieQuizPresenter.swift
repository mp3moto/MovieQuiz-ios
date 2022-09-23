import UIKit

final class MovieQuizPresenter {
    let questionsAmount: Int = 10
    private var questionNumberGlobal: Int = 0
    var currentQuestion: QuizeQuestion?
    weak var viewController: MovieQuizViewController?

    func yesButtonClicked() {
        guard let currentQuestion = currentQuestion else {
            return
        }
        if !currentQuestion.correctAnswer {
            viewController?.showAnswerResult(isCorrect: true)
        } else {
            viewController?.showAnswerResult(isCorrect: false)
        }
    }

    func noButtonClicked() {
        guard let currentQuestion = currentQuestion else {
            return
        }
        if currentQuestion.correctAnswer {
            viewController?.showAnswerResult(isCorrect: true)
        } else {
            viewController?.showAnswerResult(isCorrect: false)
        }
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
}
