import Foundation

protocol MovieQuizViewControllerProtocol: AnyObject {
    func show(quize step: QuizeStepViewModel)
    func show(quize result: QuizeResultsViewModel)

    func highlightImageBorder(isCorrectAnswer: Bool)

    func showLoadingIndicator()
    func hideLoadingIndicator()

    func showNetworkError(message: String)
    func showImageLoadError(message: String)
    func showJSONErrorMessage(message: String)
    func showErrorMessage(message: String)
}
