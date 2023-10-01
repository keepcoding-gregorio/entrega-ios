//
//  DragonBallAPIDataProvider.swift
//  Dragon Ball
//
//  Created by Gonzalo Gregorio on 30/09/2023.
//

import Foundation

final class DragonBallAPIDataProvider {
    
    private var baseComponents: URLComponents {
        var components = URLComponents()
        components.scheme = DragonBallAPIConstants.scheme
        components.host = DragonBallAPIConstants.host
        return components
    }
    
    private var token: String? {
        get {
            if let token = LocalStorageService.getToken() {
                return token
            }
            return nil
        }
        set {
            if let token = newValue {
                LocalStorageService.save(token: token)
            }
        }
    }
    
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func login(user: String, password: String, completion: @escaping (Result<String, APIErrorsEnum>) -> Void) {
        var components = baseComponents
        components.path = DragonBallAPIConstants.loginEndpoint
        
        guard let url = components.url else {
            completion(.failure(.malformedUrl))
            return
        }
        
        let loginString = String(format: "%@:%@", user, password)
        guard let loginData = loginString.data(using: .utf8) else {
            completion(.failure(.decodingFailure))
            return
        }
        let base64LoginString = loginData.base64EncodedString()
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        let task = session.dataTask(with: request) { [weak self] data, response, error in
            guard error == nil else {
                completion(.failure(.unknown))
                return
            }
            
            guard let data else {
                completion(.failure(.noData))
                return
            }
            
            let urlResponse = response as? HTTPURLResponse
            let statusCode = urlResponse?.statusCode
            
            guard statusCode == 200 else {
                completion(.failure(.statusCode(code: statusCode)))
                return
            }
            
            guard let token = String(data: data, encoding: .utf8) else {
                completion(.failure(.decodingFailure))
                return
            }
            
            completion(.success(token))
            self?.token = token
        }
        
        task.resume()
    }
    
    func getCharacters(completion: @escaping (Result<[CharacterModel], APIErrorsEnum>) -> Void) {
        var components = baseComponents
        components.path = DragonBallAPIConstants.charactersEndpoint
        
        guard let url = components.url else {
            completion(.failure(.malformedUrl))
            return
        }
        
        guard let token else {
            completion(.failure(.noToken))
            return
        }
        
        var urlComponents = URLComponents()
        urlComponents.queryItems = [URLQueryItem(name: "name", value: "")]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = urlComponents.query?.data(using: .utf8)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        resolveRequest(for: request, using: [CharacterModel].self, completion: completion)
    }
    
    func getTransformations(for character: CharacterProtocol, completion: @escaping (Result<[TransformationModel], APIErrorsEnum>) -> Void) {
        var components = baseComponents
        components.path = DragonBallAPIConstants.transformationEndpoint
        
        guard let url = components.url else {
            completion(.failure(.malformedUrl))
            return
        }
        
        guard let token else {
            completion(.failure(.noToken))
            return
        }
        
        var urlComponents = URLComponents()
        urlComponents.queryItems = [URLQueryItem(name: "id", value: character.id)]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpBody = urlComponents.query?.data(using: .utf8)
        resolveRequest(for: request, using: [TransformationModel].self, completion: completion)
    }
    
    func resolveRequest<T: Decodable>(for request: URLRequest, using type: T.Type, completion: @escaping (Result<T, APIErrorsEnum>) -> Void) {
        let task = session.dataTask(with: request) { data, response, error in
            let result: Result<T, APIErrorsEnum>
            
            defer {
                completion(result)
            }
            
            guard error == nil else {
                result = .failure(.unknown)
                return
            }
            
            guard let data else {
                result = .failure(.noData)
                return
            }
            
            guard let resource = try? JSONDecoder().decode(type, from: data) else {
                result = .failure(.decodingFailure)
                return
            }
            
            result = .success(resource)
        }
        
        task.resume()
    }
}
