import Foundation

protocol MoviesLoading {
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void)
}

struct MoviesLoader: MoviesLoading {
    private let networkClient = NetworkClient()

    private var mostPopularMoviesUrl: URL {
        guard let url = URL(string: "https://imdb-api.com/en/API/MostPopularMovies/k_3c1m97j7") else {
            preconditionFailure("Unable to construct mostPopularMoviesUrl")
        }
        return url
    }

    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void) {
        print("MoviesLoader loadMovies called")
        networkClient.fetch(url: mostPopularMoviesUrl, handler: { result in
            switch result {
            case .success(let rawData):
                print("NetworkClient returned success in closure")
                    do {
                        let JSONtoStruct = try JSONDecoder().decode(MostPopularMovies.self, from: rawData)
                        handler(.success(JSONtoStruct))
                    } catch {
                        print("Failed to parse: \(error.localizedDescription)")
                    }
            case .failure(let error):
                handler(.failure(error))
            }
        })
    }
}
