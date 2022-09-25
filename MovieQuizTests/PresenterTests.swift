import XCTest
@testable import MovieQuiz

final class MovieQuizViewControllerProtocolMock: MovieQuizViewControllerProtocol {
    func show(quize step: QuizeStepViewModel) {}
    func show(quize result: QuizeResultsViewModel) {}

    func highlightImageBorder(isCorrectAnswer: Bool) {}

    func showLoadingIndicator() {}
    func hideLoadingIndicator() {}

    func showNetworkError(message: String) {}
    func showImageLoadError(message: String) {}
    func showJSONErrorMessage(message: String) {}
    func showErrorMessage(message: String) {}
}

final class MovieQuizPresenterTests: XCTestCase {
    func testPresenterConvertModel() throws {
        let viewControllerMock = MovieQuizViewControllerProtocolMock()
        let sut = MovieQuizPresenter(viewController: viewControllerMock)

        let emptyData = Data()
        let question = QuizeQuestion(image: emptyData, text: "Question Text", correctAnswer: true, title: "Movie Title")
        let viewModel = sut.convert(model: question)

        XCTAssertNotNil(viewModel.image)
        XCTAssertEqual(viewModel.question, "Question Text")
        XCTAssertEqual(viewModel.questionNumber, "1/10")
    }
}
