import Foundation
import UIKit

protocol MoviesLoading {
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void)
}

struct MoviesLoader: MoviesLoading {
    private let networkClient: NetworkRouting

    private var mostPopularMoviesUrl: URL {
        // k_3c1m97j7
        guard let url = URL(string: "https://imdb-api.com/en/API/MostPopularMovies/k_vxtwn9l0") else {
            preconditionFailure("Unable to construct mostPopularMoviesUrl")
        }
        return url
    }
    
    init(networkClient: NetworkRouting = NetworkClient()) {
        self.networkClient = networkClient
    }

    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void) {
        networkClient.fetch(url: mostPopularMoviesUrl, handler: { result in
            switch result {
            case .success(let rawData):
                do {
                    let JSONtoStruct = try JSONDecoder().decode(MostPopularMovies.self, from: rawData)
                    handler(.success(JSONtoStruct))
                } catch {
                    handler(.failure(error))
                }
            case .failure(let error):
                handler(.failure(error))
            }
        })
    }
}
